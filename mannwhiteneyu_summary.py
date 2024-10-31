import pandas as pd
import os
import numpy as np

def read_comparison_files():
    """Read all mannwhitneyu results CSV files and return as a dictionary"""
    results = {}
    for filename in os.listdir('.'):
        if filename.startswith('mannwhitneyu_results_') and filename.endswith('.csv'):
            comparison = filename.replace('mannwhitneyu_results_', '').replace('.csv', '')
            df = pd.read_csv(filename)
            results[comparison] = df
    return results

def get_comparison_result(p_value, alpha=0.05):
    """Determine if there's a significant difference based on p-value"""
    if p_value > alpha:
        return 'N'  # No significant difference
    return '+' if p_value < alpha else '-'

def check_comparison(results, func, dim, acc, comp1, comp2):
    """
    Check comparison based on the first method's perspective
    Returns: final_result, details for logging
    """
    details = []
    
    # First check the direct comparison (comp1_vs_comp2)
    key1 = f"{comp1}_vs_{comp2}"
    result = None
    
    if key1 in results:
        mask = (results[key1]['Function'] == func) & \
               (results[key1]['Dimension'] == dim) & \
               (results[key1]['Accuracy'] == acc)
        if any(mask):
            p_value = results[key1].loc[mask, 'P-Value'].iloc[0]
            result = get_comparison_result(p_value)
            details.append(f"{key1}: p={p_value:.6f} ({result})")
    
    # Return early if we have a significant result
    if result in ['+', '-']:
        return result, details
    
    # Check the reverse comparison if direct comparison showed no significance
    key2 = f"{comp2}_vs_{comp1}"
    if key2 in results:
        mask = (results[key2]['Function'] == func) & \
               (results[key2]['Dimension'] == dim) & \
               (results[key2]['Accuracy'] == acc)
        if any(mask):
            p_value = results[key2].loc[mask, 'P-Value'].iloc[0]
            reverse_result = get_comparison_result(p_value)
            details.append(f"{key2}: p={p_value:.6f} ({reverse_result})")
            
            # If reverse comparison shows significance, flip the result
            if reverse_result != 'N':
                result = '-' if reverse_result == '+' else '+'
                details.append(f"Using flipped result from reverse comparison")
            elif result is None:
                result = 'N'
    
    if result is None:
        result = 'NA'
    
    return result, details

def custom_sort_function(func):
    """Custom sorting function for the Function column"""
    # Define the desired order
    function_order = ['f1', 'f2', 'f4', 'f8', 'f13', 'f15']
    try:
        return function_order.index(func)
    except ValueError:
        # If the function is not in the list, put it at the end
        return len(function_order)

def aggregate_comparisons(results):
    """Aggregate all comparisons into a single DataFrame with logging"""
    # Get unique combinations
    all_conditions = set()
    for df in results.values():
        conditions = list(zip(df['Function'], df['Dimension'], df['Accuracy']))
        all_conditions.update(conditions)
    
    aggregated_results = []
    all_details = []
    
    # Sort conditions using custom function order
    sorted_conditions = sorted(
        all_conditions,
        key=lambda x: (
            custom_sort_function(x[0]),  # Function
            x[1],                        # Dimension
            x[2]                         # Accuracy
        )
    )
    
    for func, dim, acc in sorted_conditions:
        row_data = {
            'Function': func,
            'Dimension': dim,
            'Accuracy': acc
        }
        
        # Define the comparisons we want to show in the final results
        comparisons = [
            ('ps', 'gb'),  # ps vs gb
            ('ps', 'ib'),  # ps vs ib
            ('ib', 'gb'),  # ib vs gb
        ]
        
        comparison_details = []
        for first, second in comparisons:
            result, details = check_comparison(
                results, func, dim, acc, first, second
            )
            row_data[f"{first}_vs_{second}"] = result
            
            if details:
                comparison_details.extend([
                    f"\nFunction: {func}, Dimension: {dim}, Accuracy: {acc}",
                    f"Comparison: {first} vs {second}",
                    *details
                ])
        
        if comparison_details:
            all_details.extend(comparison_details)
        
        aggregated_results.append(row_data)
    
    # Create DataFrame
    df = pd.DataFrame(aggregated_results)
    
    # Write details to log file
    with open('comparison_details.log', 'w') as f:
        f.write('\n'.join(all_details))
    
    return df

def main():
    # Read all comparison files
    results = read_comparison_files()
    
    # Aggregate results
    aggregated_df = aggregate_comparisons(results)
    
    # Sort by Accuracy and Dimension within each Function group
    aggregated_df['Accuracy'] = pd.to_numeric(aggregated_df['Accuracy'])
    aggregated_df = aggregated_df.sort_values(['Function', 'Dimension', 'Accuracy'])
    
    # Save to CSV
    aggregated_df.to_csv('aggregated_comparisons.csv', index=False)
    print("Results have been saved to 'aggregated_comparisons.csv'")
    print("Detailed comparison log has been saved to 'comparison_details.log'")

if __name__ == "__main__":
    main()
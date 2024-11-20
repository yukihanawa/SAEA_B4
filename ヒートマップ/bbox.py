import fitz  # PyMuPDF

# PDFファイルを開く
pdf_path = "heatmap_gbafs_f8_d10.pdf"
doc = fitz.open(pdf_path)

# 各ページのbboxを確認
for page_num in range(doc.page_count):
    page = doc[page_num]
    print(f"Page {page_num + 1}")

    # ページのMediaBoxを取得
    mediabox = page.rect  # PyMuPDFではrectでMediaBox相当の情報を取得
    print(f"  MediaBox: {mediabox}")
    
    # CropBoxなどの他のボックス情報も取得できる（同じ場合が多い）
    cropbox = page.cropbox
    print(f"  CropBox: {cropbox}")

    # 他にも、必要に応じてBleedBox, TrimBox, ArtBoxの情報を取得する
    # これらのボックスが設定されている場合のみ出力される
    print(f"  BleedBox: {page.bleedbox}")
    print(f"  TrimBox: {page.trimbox}")
    print(f"  ArtBox: {page.artbox}")

doc.close()
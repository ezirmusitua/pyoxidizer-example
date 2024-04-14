from pathlib import Path
import pdfplumber

def print_content(pdf_path):
    with pdfplumber.open(pdf_path) as pdf:
        # 遍历 PDF 中的每一页
        for page in pdf.pages:
            # 提取页面文本并打印
            text = page.extract_text()
            print(text)

if __name__ == '__main__':
    import sys
    if len(sys.argv) < 2:
        print("[ERROR] 请提供 PDF 文件路径作为命令行参数。")
        sys.exit(1)

    pdf_path = sys.argv[1].strip()

    if not Path(pdf_path).exists():
        print(f"[ERROR] 文件 {pdf_path} 不存在。")
        sys.exit(1)

    print_content(pdf_path)
 

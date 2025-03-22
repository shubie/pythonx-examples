Mix.install([
  {:pythonx, "~> 0.3.0"}
])

Pythonx.uv_init("""
[project]
name = "ppdf"
version = "0.1.0"
description = "Add your description here"
readme = "README.md"
requires-python = ">=3.13"
dependencies = [
    "pdfplumber>=0.11.5",
]
""")

{_, globals} =
  Pythonx.eval(
    """
    import pdfplumber
    from itertools import groupby
    from typing import Dict, List
    import json


    def extract_pdf_content(pdf_path: str, page_number: int = 0) -> Dict:

        with pdfplumber.open(pdf_path) as pdf:
            page = pdf.pages[page_number]
            words = page.extract_words()
            sentences = group_words_into_sentences(words)
            paragraphs = group_into_paragraphs(sentences)

            # Create structured output
            result = {
                "document": {
                    "path": pdf_path,
                    "page": page_number,
                    "paragraphs": []
                }
            }

            for idx, para in enumerate(paragraphs, 1):
                paragraph_data = {
                    "id": idx,
                    "text": para['text'],
                    "position": {
                        "x0": round(para['x0'], 2),
                        "x1": round(para['x1'], 2),
                        "top": round(para['top'], 2),
                        "bottom": round(para['bottom'], 2)
                    },
                    "metadata": {
                        "width": round(para['x1'] - para['x0'], 2),
                        "height": round(para['bottom'] - para['top'], 2)
                    }
                }
                result["document"]["paragraphs"].append(paragraph_data)

            return result


    def group_words_into_sentences(words, y_tolerance=3):
        sorted_words = sorted(words, key=lambda w: (round(w['top']/y_tolerance)*y_tolerance, w['x0']))

        grouped_lines = []
        for _, line_words in groupby(sorted_words, key=lambda w: round(w['top']/y_tolerance)*y_tolerance):
            line_words = list(line_words)
            if line_words:
                sentence = ' '.join(word['text'] for word in line_words)
                sentence_info = {
                    'text': sentence,
                    'x0': min(w['x0'] for w in line_words),
                    'x1': max(w['x1'] for w in line_words),
                    'top': min(w['top'] for w in line_words),
                    'bottom': max(w['bottom'] for w in line_words)
                }
                grouped_lines.append(sentence_info)
        return grouped_lines


    def group_into_paragraphs(sentences, paragraph_spacing=15):
        sorted_sentences = sorted(sentences, key=lambda s: s['top'])

        paragraphs = []
        current_paragraph = []

        for i, sentence in enumerate(sorted_sentences):
            current_paragraph.append(sentence)

            if i == len(sorted_sentences) - 1 or \
               (sorted_sentences[i + 1]['top'] - sentence['bottom']) > paragraph_spacing:
                paragraph_text = ' '.join(s['text'] for s in current_paragraph)
                paragraph_info = {
                    'text': paragraph_text,
                    'x0': min(s['x0'] for s in current_paragraph),
                    'x1': max(s['x1'] for s in current_paragraph),
                    'top': min(s['top'] for s in current_paragraph),
                    'bottom': max(s['bottom'] for s in current_paragraph)
                }
                paragraphs.append(paragraph_info)
                current_paragraph = []

        return paragraphs


    def save_to_json(data: Dict, output_path: str):
        # \"""Save the extracted data to a JSON file\"""
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)


    """,
    %{}
  )

{result, _} =
  Pythonx.eval(
    """
    pdf_path = "isdb.pdf"
    output_path = "extracted_paragraphs.json"

    # Extract content
    # result = extract_pdf_content(pdf_path)

    # Save to JSON file
    # save_to_json(result, output_path)

    extract_pdf_content(pdf_path)

    # Print summary
    # print(f"Processed PDF: {pdf_path}")
    # print(f"Found {len(result['document']['paragraphs'])} paragraphs")
    # print(f"Results saved to: {output_path}")

    # return result
    """,
    globals
  )

IO.inspect("Result in elixir")
IO.inspect(result)

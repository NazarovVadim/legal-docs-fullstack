
from fastapi import FastAPI, Form, Request
from fastapi.responses import JSONResponse, FileResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
import uuid
import os
from weasyprint import HTML
from pathlib import Path

app = FastAPI()

# Подключаем фронтенд
app.mount("/static", StaticFiles(directory="backend/static"), name="static")
templates = Jinja2Templates(directory="backend/templates")

output_dir = Path("backend/generated")
output_dir.mkdir(parents=True, exist_ok=True)

@app.get("/", response_class=HTMLResponse)
def serve_frontend():
    return FileResponse("backend/static/index.html")

@app.post("/generate/")
async def generate_pdf(name: str = Form(...), address: str = Form(...)):
    filename = f"{uuid.uuid4()}.pdf"
    pdf_path = output_dir / filename

    html = templates.get_template("contract_template.html").render(
        name=name, address=address
    )
    HTML(string=html).write_pdf(str(pdf_path))

    return JSONResponse({"download_url": f"/download/{filename}"})

@app.get("/download/{filename}")
async def download_file(filename: str):
    file_path = output_dir / filename
    if file_path.exists():
        return FileResponse(path=file_path, filename=filename, media_type='application/pdf')
    return JSONResponse({"error": "File not found"}, status_code=404)

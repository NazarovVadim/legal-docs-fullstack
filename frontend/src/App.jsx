import { useState } from "react";

function App() {
  const [formData, setFormData] = useState({ name: "", address: "" });
  const [downloadLink, setDownloadLink] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    const form = new FormData();
    form.append("name", formData.name);
    form.append("address", formData.address);

    const res = await fetch("/generate/", {
      method: "POST",
      body: form,
    });
    const data = await res.json();
    setDownloadLink(data.download_url);
  };

  return (
    <div className="p-10 max-w-xl mx-auto">
      <h1 className="text-2xl font-bold mb-4">Создание договора</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <input type="text" placeholder="ФИО" className="border p-2 w-full"
               onChange={(e) => setFormData({ ...formData, name: e.target.value })} />
        <input type="text" placeholder="Адрес" className="border p-2 w-full"
               onChange={(e) => setFormData({ ...formData, address: e.target.value })} />
        <button className="bg-blue-600 text-white px-4 py-2 rounded">Создать PDF</button>
      </form>
      {downloadLink && (
        <a href={downloadLink} className="block mt-4 text-green-600" target="_blank">Скачать договор</a>
      )}
    </div>
  );
}

export default App;

import React, { useState, useEffect } from 'react';

const API_BASE = 'http://localhost:5000/api';

export default function AdminResourcePanel() {
  const [resources, setResources] = useState([]);
  const [categories, setCategories] = useState([]);
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    file_url: '',
    sub_category_id: '',
    is_featured: false,
  });
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');

  useEffect(() => {
    fetchResources();
    fetchCategories();
  }, []);

  const fetchResources = async () => {
    const res = await fetch(`${API_BASE}/resources`);
    const json = await res.json();
    if (json.success) setResources(json.data);
  };

  const fetchCategories = async () => {
    const res = await fetch(`${API_BASE}/categories`);
    const json = await res.json();
    if (json.success) setCategories(json.data);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage('');

    try {
      const res = await fetch(`${API_BASE}/admin/resources`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData),
      });

      const json = await res.json();
      if (json.success) {
        setMessage('Resource successfully created!');
        setFormData({ title: '', description: '', file_url: '', sub_category_id: '', is_featured: false });
        fetchResources();
      } else {
        setMessage('Error: ' + json.error);
      }
    } catch (err) {
      setMessage('Failed to connect to backend server.');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this resource?')) return;
    await fetch(`${API_BASE}/admin/resources/${id}`, { method: 'DELETE' });
    fetchResources();
  };

  return (
    <div style={{ padding: '24px', fontFamily: 'sans-serif', maxWidth: '1200px', margin: '0 auto' }}>
      <h1>Mfano Bora Resources - Admin Panel</h1>
      <p style={{ color: '#666' }}>Upload and manage PDFs and resources for the website.</p>

      {/* CREATE FORM */}
      <div style={{ background: '#f5f5f5', padding: '20px', borderRadius: '8px', marginBottom: '30px' }}>
        <h2>Add New Resource</h2>
        {message && <p style={{ fontWeight: 'bold', color: message.startsWith('Error') ? 'red' : 'green' }}>{message}</p>}
        
        <form onSubmit={handleSubmit} style={{ display: 'grid', gap: '15px' }}>
          <div>
            <label style={{ display: 'block', fontWeight: 'bold' }}>Resource Title:</label>
            <input 
              type="text" 
              required
              value={formData.title} 
              onChange={(e) => setFormData({ ...formData, title: e.target.value })} 
              style={{ width: '100%', padding: '8px', marginTop: '4px' }} 
              placeholder="e.g., Industrial Attachment Application Form 2026"
            />
          </div>

          <div>
            <label style={{ display: 'block', fontWeight: 'bold' }}>Category & Sub-Category:</label>
            <select 
              required
              value={formData.sub_category_id} 
              onChange={(e) => setFormData({ ...formData, sub_category_id: e.target.value })}
              style={{ width: '100%', padding: '8px', marginTop: '4px' }}
            >
              <option value="">Select Sub-Category</option>
              {categories.map((cat) => (
                <optgroup key={cat.id} label={cat.name}>
                  {cat.subcategories.map((sub) => (
                    <option key={sub.id} value={sub.id}>{sub.name}</option>
                  ))}
                </optgroup>
              ))}
            </select>
          </div>

          <div>
            <label style={{ display: 'block', fontWeight: 'bold' }}>Document URL (AWS S3 or Cloudinary):</label>
            <input 
              type="url" 
              required
              value={formData.file_url} 
              onChange={(e) => setFormData({ ...formData, file_url: e.target.value })} 
              style={{ width: '100%', padding: '8px', marginTop: '4px' }} 
              placeholder="https://storage.mfanoboraafrica.com/docs/attachment-form.pdf"
            />
          </div>

          <div>
            <label style={{ display: 'block', fontWeight: 'bold' }}>Description:</label>
            <textarea 
              required
              value={formData.description} 
              onChange={(e) => setFormData({ ...formData, description: e.target.value })} 
              style={{ width: '100%', padding: '8px', marginTop: '4px', height: '80px' }} 
              placeholder="Provide a concise summary of the document content..."
            />
          </div>

          <div>
            <label style={{ display: 'flex', alignItems: 'center', gap: '8px', cursor: 'pointer' }}>
              <input 
                type="checkbox" 
                checked={formData.is_featured} 
                onChange={(e) => setFormData({ ...formData, is_featured: e.target.checked })} 
              />
              Mark as "Featured Resource" on Hero Banner
            </label>
          </div>

          <button 
            type="submit" 
            disabled={loading}
            style={{ padding: '10px 20px', background: '#0056b3', color: '#fff', border: 'none', borderRadius: '4px', cursor: 'pointer' }}
          >
            {loading ? 'Saving...' : 'Add Resource'}
          </button>
        </form>
      </div>

      {/* EXISTING RESOURCES TABLE */}
      <h2>Existing Resources ({resources.length})</h2>
      <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
        <thead>
          <tr style={{ background: '#333', color: '#fff' }}>
            <th style={{ padding: '10px' }}>ID</th>
            <th style={{ padding: '10px' }}>Title</th>
            <th style={{ padding: '10px' }}>Category</th>
            <th style={{ padding: '10px' }}>Downloads</th>
            <th style={{ padding: '10px' }}>Featured</th>
            <th style={{ padding: '10px' }}>Actions</th>
          </tr>
        </thead>
        <tbody>
          {resources.map((res) => (
            <tr key={res.id} style={{ borderBottom: '1px solid #ddd' }}>
              <td style={{ padding: '10px' }}>{res.id}</td>
              <td style={{ padding: '10px', fontWeight: 'bold' }}>{res.title}</td>
              <td style={{ padding: '10px' }}>{res.category_name} &gt; {res.sub_category_name}</td>
              <td style={{ padding: '10px' }}>{res.download_count}</td>
              <td style={{ padding: '10px' }}>{res.is_featured ? 'Yes' : 'No'}</td>
              <td style={{ padding: '10px' }}>
                <a href={res.file_url} target="_blank" rel="noreferrer" style={{ marginRight: '10px' }}>View</a>
                <button onClick={() => handleDelete(res.id)} style={{ color: 'red', cursor: 'pointer' }}>Delete</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

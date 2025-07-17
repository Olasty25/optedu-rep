import React, { useState } from 'react';

const ApiConnector: React.FC = () => {
    const [data, setData] = useState<any>(null);
    const [error, setError] = useState<string | null>(null);
    const [url, setUrl] = useState<string>('');
    const [payload, setPayload] = useState<string>('');

    const fetchData = async () => {
        try {
            const response = await fetch(url);
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            const result = await response.json();
            setData(result);
            setError(null);
        } catch (err: any) {
            setError(err.message);
            setData(null);
        }
    };

    const postData = async () => {
        try {
            const response = await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: payload,
            });
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            const result = await response.json();
            setData(result);
            setError(null);
        } catch (err: any) {
            setError(err.message);
            setData(null);
        }
    };

    return (
        <div className="container mt-4">
            <h2 className="mb-3">API Connector</h2>
            <div className="mb-3">
                <input
                    type="text"
                    className="form-control mb-2"
                    placeholder="API URL"
                    value={url}
                    onChange={e => setUrl(e.target.value)}
                />
                <textarea
                    className="form-control mb-2"
                    placeholder="Payload (JSON dla POST)"
                    value={payload}
                    onChange={e => setPayload(e.target.value)}
                    rows={3}
                />
                <div>
                    <button className="btn btn-primary me-2" onClick={fetchData}>GET</button>
                    <button className="btn btn-success me-2" onClick={postData}>POST</button>
                </div>
            </div>
            {error && <div className="alert alert-danger">Error: {error}</div>}
            <pre className="bg-light p-3 border rounded">{JSON.stringify(data, null, 2)}</pre>
        </div>
    );
};

export default ApiConnector;
import React from 'react';
import Toolbar from './components/Toolbar';
import Sidebar from './components/Sidebar';
import ApiConnector from './components/ApiConnector';

const App: React.FC = () => {
    return (
        <div>
            <Toolbar />
            <div style={{ display: 'flex' }}>
                <Sidebar />
                <main style={{ marginLeft: '200px', padding: '20px' }}>
                    <h1>Welcome to the React App</h1>
                    <ApiConnector />
                </main>
            </div>
        </div>
    );
};

export default App;
import React from 'react';

const Sidebar: React.FC = () => {
    return (
        <div className="sidebar">
            <h2>Sidebar</h2>
            <ul>
                <li><a href="#link1">Link 1</a></li>
                <li><a href="#link2">Link 2</a></li>
                <li><a href="#link3">Link 3</a></li>
            </ul>
        </div>
    );
};

export default Sidebar;
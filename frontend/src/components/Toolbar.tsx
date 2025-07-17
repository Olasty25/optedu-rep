import React from 'react';

const Toolbar: React.FC = () => (
    <nav className="navbar navbar-expand-lg navbar-dark bg-primary">
        <div className="container-fluid">
            <a className="navbar-brand" href="#">OptEdu</a>
            <button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span className="navbar-toggler-icon"></span>
            </button>
            <div className="collapse navbar-collapse" id="navbarNav">
                <ul className="navbar-nav ms-auto">
                    <li className="nav-item">
                        <a className="nav-link active" aria-current="page" href="#">Home</a>
                    </li>
                    <li className="nav-item">
                        <a className="nav-link" href="#">API</a>
                    </li>
                    <li className="nav-item">
                        <a className="nav-link" href="#">Kontakt</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
);

export default Toolbar;
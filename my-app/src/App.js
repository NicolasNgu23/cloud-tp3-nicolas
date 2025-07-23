import logo from './logo.svg';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <h1>Mon Application React</h1>
        <p>
          Hébergée sur <strong>AWS S3</strong> avec <strong>CloudFront</strong>
        </p>
        <div className="features">
          <div className="feature">
            <h3>🚀 Déploiement automatisé</h3>
            <p>Avec Terraform et AWS CLI</p>
          </div>
          <div className="feature">
            <h3>⚡ CDN Global</h3>
            <p>CloudFront pour des performances optimales</p>
          </div>
          <div className="feature">
            <h3>💰 Économique</h3>
            <p>Hébergement statique sur S3</p>
          </div>
        </div>
        <p className="build-info">
          Build: {new Date().toLocaleString('fr-FR')}
        </p>
      </header>
    </div>
  );
}

export default App;

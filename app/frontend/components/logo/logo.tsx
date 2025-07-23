import { type ReactElement } from 'react';
import logo from '../../../frontend/images/logo.webp';
import './logo.scss';

export function Logo(): ReactElement {
  return <img className="logo" src={logo} alt="Nerdgeschoss Logo" />;
}

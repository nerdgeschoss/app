import React, { useState } from 'react';
import { Props } from './home.schema.js';

export default function Home({ currentUser }: Props): JSX.Element {
  const [counter, setCounter] = useState(0);
  return (
    <div id="something">
      <h1>Home</h1>
      <p>Welcome to the home page, {currentUser.firstName}</p>
      <p>Counter: {counter}</p>
      <button onClick={() => setCounter(counter + 1)}>Increment</button>
    </div>
  );
}

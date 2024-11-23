import React, { useState } from 'react';
import { PageProps } from '../../../data.d';
import { Sidebar } from '../../javascript/components/sidebar/sidebar';

export default function Home({
  data: { currentUser },
}: PageProps<'pages/home'>): JSX.Element {
  const [counter, setCounter] = useState(0);
  return (
    <>
      <Sidebar />
      <div className="content">
        <h1>Home</h1>
        <p>Welcome to the home page, {currentUser.firstName}</p>
        <p>Counter: {counter}</p>
        <button onClick={() => setCounter(counter + 1)}>Increment</button>
      </div>
    </>
  );
}

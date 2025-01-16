import React from 'react';
import { useErrors } from '../../util/errors';
import { Stack } from '../stack/stack';
import './errors.scss';

export function Errors(): JSX.Element {
  const errors = useErrors();
  return (
    <div className="errors">
      <Stack size={4}>
        {errors.map((e) => (
          <div className="errors__notification" key={e.message}>
            <button
              className="errors__notification-close"
              onClick={(event) => {
                event.preventDefault();
                e.confirm();
              }}
            >
              X
            </button>
            {e.message}
          </div>
        ))}
      </Stack>
    </div>
  );
}

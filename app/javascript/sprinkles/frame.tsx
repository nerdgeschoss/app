import React, { FunctionComponent, useEffect } from 'react';
import { Meta } from './meta';
import { useReaction } from './reaction';

interface Props {
  url: string;
}

export function Frame({ url }: Props): JSX.Element | null {
  const reaction = useReaction();
  const [Component, setComponent] = React.useState<FunctionComponent | null>(
    null
  );
  const [data, setData] = React.useState<Meta | null>(null);
  useEffect(() => {
    reaction.history.cache.fetch(url).then((meta) => {
      setData(meta.meta.props);
      reaction
        .componentFor(meta.meta.component)
        .then((component) => setComponent(() => component));
    });
  }, [url]);
  console.log('data', url, data, !!data, !!Component);
  if (!Component) return null;
  if (!data) return null;
  console.log('frame render');
  return <Component data={data} />;
}

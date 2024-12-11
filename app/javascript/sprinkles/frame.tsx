import React, { FunctionComponent, useEffect } from 'react';
import { MetaCacheSubscription } from './meta_cache';
import { useReaction } from './reaction';

interface Props {
  url: string;
}

export function Frame({ url }: Props): JSX.Element | null {
  const reaction = useReaction();
  const [Component, setComponent] = React.useState<FunctionComponent<{
    data: any;
  }> | null>(null);
  const [data, setData] = React.useState<any | null>(null);
  useEffect(() => {
    let subscription: MetaCacheSubscription | null = null;
    reaction.history.cache.fetch(url).then((meta) => {
      setData(meta.meta.props);
      subscription = reaction.history.cache.subscribe(url, (data) =>
        setData(data)
      );
      reaction
        .componentFor(meta.meta.component)
        .then((component) => setComponent(() => component));
    });
    return () => {
      subscription?.unsubscribe();
    };
  }, [url]);
  if (!Component) return null;
  if (!data) return null;
  return <Component data={data} />;
}

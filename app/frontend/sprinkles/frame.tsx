import React, { FunctionComponent, useEffect, useState } from 'react';
import { MetaCacheSubscription } from './meta_cache';
import { useReaction } from './reaction';

interface Props {
  url: string;
  awaitLoading?: boolean;
}

interface State {
  data: unknown;
  component: FunctionComponent<{ data: unknown }> | null;
}

export function Frame({ url, awaitLoading }: Props): JSX.Element | null {
  const reaction = useReaction();
  const [state, setComponentState] = useState<State | null>(null);
  useEffect(() => {
    let subscription: MetaCacheSubscription | null = null;
    reaction.history.cache
      .fetch(url, { force: awaitLoading })
      .then((result) => {
        const data = result.meta.props;
        reaction.componentFor(result.meta.component).then((component) => {
          setComponentState({ data, component });
          subscription = reaction.history.cache.subscribe(url, (newData) => {
            setComponentState({ data: newData, component });
          });
        });
      });
    return () => {
      subscription?.unsubscribe();
    };
  }, [url]);
  const data = state?.data;
  const Component = state?.component;
  if (!Component) return null;
  if (!data) return null;
  return <Component data={data} />;
}

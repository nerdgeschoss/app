import { useState } from 'react';
import { wrapArray } from './basic_hooks';

export interface Selection<T> {
  has: (item: T) => boolean;
  hasEvery: (items: T[]) => boolean;
  hasSome: (items: T[]) => boolean;
  add: (item: T | T[]) => void;
  all: Set<T>;
  values: T[];
  size: number;
  allSelected: boolean;
  deselected: T[];
  toggleAll: (items: T[]) => void;
  selectAll: (items: T[]) => void;
  remove: (item: T | T[]) => void;
  toggle: (item: T | T[]) => void;
  clear: () => void;
}

export function useSelection<T>(initialValue?: T[]): Selection<T> {
  const [allSelected, setAllSelected] = useState(false);
  const [selection, setSelection] = useState<Set<T>>(new Set(initialValue));
  const [deselected, setDeselected] = useState<Set<T>>(new Set());

  function updateSetValue(
    value: Set<T>,
    items: T | T[],
    type: 'add' | 'remove'
  ): Set<T> {
    const newValue = new Set(value);
    wrapArray(items).forEach((item) => {
      if (type === 'add') {
        newValue.add(item);
      } else {
        newValue.delete(item);
      }
    });
    return new Set(newValue);
  }

  function add(items: T | T[]): void {
    setSelection((val) => updateSetValue(val, items, 'add'));
    setDeselected((val) => updateSetValue(val, items, 'remove'));
  }

  function remove(items: T | T[]): void {
    setSelection((val) => updateSetValue(val, items, 'remove'));
    setDeselected((val) => updateSetValue(val, items, 'add'));
  }

  function clear(): void {
    setSelection(new Set());
    setDeselected(new Set());
    setAllSelected(false);
  }

  return {
    all: selection,
    values: Array.from(selection),
    size: selection.size,
    allSelected,
    deselected: Array.from(deselected),
    has: (item) => selection.has(item),
    hasEvery: (items) => items.every((e) => selection.has(e)),
    hasSome: (items) => items.some((e) => selection.has(e)),
    add,
    remove,
    clear,
    toggle: (items) => {
      setAllSelected(false);
      setSelection((val) => {
        const newValue = new Set(val);
        wrapArray(items).forEach((item) =>
          newValue.has(item) ? newValue.delete(item) : newValue.add(item)
        );
        return new Set(newValue);
      });
      setDeselected((val) => {
        const newValue = new Set(val);
        wrapArray(items).forEach((item) =>
          newValue.has(item) ? newValue.add(item) : newValue.delete(item)
        );
        return new Set(newValue);
      });
    },
    toggleAll: (items: T[]) => {
      setAllSelected(false);
      if (selection.size === items.length) {
        clear();
      } else {
        add(items);
      }
    },
    selectAll: (items: T[]) => {
      setAllSelected(true);
      add(items);
    },
  };
}

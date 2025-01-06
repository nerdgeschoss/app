'use client';
import './modal.scss';
import React, {
  useState,
  useContext,
  useMemo,
  createContext,
  ReactNode,
  useEffect,
} from 'react';
import classnames from 'classnames';
import { Frame } from '../../sprinkles/frame';

interface ModalProps {
  open: boolean;
  children: React.ReactNode;
  large?: boolean;
  onClose: () => void;
}

function Modal(props: ModalProps): JSX.Element {
  const { children } = props;

  const [open, setOpen] = useState(false);

  useEffect(() => {
    if (props.open !== open) {
      setOpen(props.open);
    }
  }, [props.open]);

  return (
    <div
      className={classnames('modal', {
        'modal--open': open,
        'modal--center': true,
        'modal--large': props.large,
      })}
    >
      <div
        className={classnames('modal__background', {
          'modal__background--fade-in': open,
          'modal__background--fade-out': !props.open,
        })}
      />
      <div className="modal__content">{children}</div>
    </div>
  );
}

interface ModalPresenter {
  /// Close the modal with the given handle
  close(handle?: string): void;
  /// Present a modal with the given component and props
  present(url: string, options?: { handle?: string; large?: boolean }): void;
}

const ModalPresenterContext = createContext<ModalPresenter>({
  present: () => {},
  close: () => {},
});

interface ModalInfo {
  id: string;
  handle?: string;
  close: () => void;
}

const ModalInfoContext = createContext<ModalInfo>({
  id: '',
  close: () => {},
});

export function useModal(): ModalPresenter {
  return useContext(ModalPresenterContext);
}

export function useModalInfo(): ModalInfo {
  return useContext(ModalInfoContext);
}

interface ModalData {
  id: string;
  handle?: string;
  large?: boolean;
  url: string;
  open: boolean;
}

export function ModalWrapper({
  children,
}: {
  children: ReactNode;
}): JSX.Element {
  const [modals, setModals] = useState<ModalData[]>([]);

  const closeId = useMemo(() => {
    return (id: string) => {
      setModals((modals) =>
        modals.map((modal) =>
          modal.id === id ? { ...modal, open: false } : modal
        )
      );
      setTimeout(() => {
        setModals((modals) => modals.filter((e) => e.id !== id));
      }, 300);
    };
  }, [setModals]);

  const presenter: ModalPresenter = useMemo(() => {
    return {
      close: (handle) =>
        modals
          .filter((modal) => modal.handle === handle)
          .forEach((modal) => closeId(modal.id)),
      present(url, options = {}) {
        const id = Date.now().toString();
        setModals((modals) => [
          ...modals,
          {
            ...options,
            url,
            open: true,
            id,
          },
        ]);
      },
    };
  }, [modals]);

  useEffect(() => {
    document.body.classList.toggle('with-modal', modals.length > 0);
  }, [modals.length]);

  return (
    <ModalPresenterContext.Provider value={presenter}>
      {modals.length > 0 && (
        <div className="modal__stack">
          {modals.map((modal) => (
            <ModalInfoContext.Provider
              value={{
                id: modal.id,
                handle: modal.handle,
                close: () => closeId(modal.id),
              }}
              key={modal.id}
            >
              <Modal
                open={modal.open}
                onClose={() => closeId(modal.id)}
                large={modal.large}
              >
                <Frame url={modal.url} />
              </Modal>
            </ModalInfoContext.Provider>
          ))}
        </div>
      )}
      {children}
    </ModalPresenterContext.Provider>
  );
}

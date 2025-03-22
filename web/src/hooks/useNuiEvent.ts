import { MutableRefObject, useEffect, useRef, useCallback } from "react";
import { noop } from "../utils/misc";

interface NuiMessageData<T = unknown> {
  action: string;
  data: T;
}

type NuiHandlerSignature<T> = (data: T) => void;

/**
 * A hook that manages event listeners for receiving data from the client scripts.
 * @param action The specific `action` that should be listened for.
 * @param handler The callback function that will handle data relayed by this hook.
 *
 * @example
 * useNuiEvent<{ visibility: boolean; wasVisible: string }>("setVisible", (data) => {
 *   // Handle event data here
 * });
 */
export const useNuiEvent = <T = unknown>(
  action: string,
  handler: NuiHandlerSignature<T>
) => {
  const savedHandler: MutableRefObject<NuiHandlerSignature<T>> = useRef(noop);

  // Stable reference for handler function
  const stableHandler = useCallback((data: T) => {
    if (savedHandler.current) {
      savedHandler.current(data);
    }
  }, []);

  useEffect(() => {
    savedHandler.current = handler || noop;
  }, [handler]);

  useEffect(() => {
    const eventListener = (event: MessageEvent<NuiMessageData<T>>) => {
      if (!event.data || typeof event.data !== "object") return;

      const { action: eventAction, data } = event.data;
      if (eventAction === action) {
        stableHandler(data);
      }
    };

    window.addEventListener("message", eventListener);
    
    return () => {
      window.removeEventListener("message", eventListener);
    };
  }, [action, stableHandler]);
};

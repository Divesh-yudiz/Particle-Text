declare const debounce: (callback: (event: unknown) => void, duration: number) => (event?: unknown) => void;
export default debounce;

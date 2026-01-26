let i = 1;

const sum = (
  a: number,
  b: number,
  c?: string, // Optional param
  d: number = 0 // Default param
): number | string => {
  let result: string | number;
  result = a + b + d;
  if (c) {
    result = a + b + c;
  }
  return result;
};

export function


const fs = require('fs');

fs.readFile('input.txt', 'utf8', (err, data) => {
  if (err) {
    console.error(err);
    return;
  }

  let input = data
    .replaceAll('^', '.')
    .replaceAll('>', '.')
    .replaceAll('v', '.')
    .replaceAll('<', '.');

  let grid = input.split('\n').map((str) => str.split(''));
  const n = grid.length;
  const m = grid[0].length;
  for (let i = 0; i < n; i++)
    for (let j = 0; j < m; j++)
      if (
        grid[i][j] === '.' &&
        (grid[i][j - 1] === '.' ? 1 : 0) +
          (grid[i][j + 1] === '.' ? 1 : 0) +
          (grid[i - 1]?.[j] === '.' ? 1 : 0) +
          (grid[i + 1]?.[j] === '.' ? 1 : 0) >=
          3
      )
        grid[i][j] = 'X';

  grid[n - 2][m - 2] = 'X';

  let path = input.split('\n').map((str) => str.split(''));

  function getMaxSteps(x = 1, y = 0) {
    if (x === m - 2 && y === n - 1) return 0;
    if (path[y]?.[x] !== '.') return -Infinity;
    path[y][x] = 'O';
    let nextSteps = [];
    let nextY = y;
    let nextX = x;
    while (
      grid[nextY][nextX] === '.' &&
      (path[nextY - 1]?.[nextX] === '.' ||
        path[nextY + 1]?.[nextX] === '.' ||
        path[nextY][nextX - 1] === '.' ||
        path[nextY][nextX + 1] === '.')
    ) {
      if (path[nextY - 1]?.[nextX] === '.') nextSteps.push([nextX, --nextY]);
      else if (path[nextY + 1]?.[nextX] === '.')
        nextSteps.push([nextX, ++nextY]);
      else if (path[nextY][nextX - 1] === '.') nextSteps.push([--nextX, nextY]);
      else if (path[nextY][nextX + 1] === '.') nextSteps.push([++nextX, nextY]);
      path[nextY][nextX] = 'O';
    }
    let result =
      1 +
      nextSteps.length +
      Math.max(
        getMaxSteps(nextX, nextY - 1),
        getMaxSteps(nextX + 1, nextY),
        getMaxSteps(nextX, nextY + 1),
        getMaxSteps(nextX - 1, nextY)
      );
    for (const [cx, cy] of nextSteps) path[cy][cx] = '.';
    path[y][x] = '.';
    return result;
  }

  let output = getMaxSteps() - 1;
  console.log(output);
});

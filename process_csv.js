const fs = require('fs');
const scale = 0.5;
const W = Math.floor(1792 * scale);
const H = Math.floor(1120 * scale);
console.log(W, H);
const map = new Array(W * H);
for (let i = 0; i < map.length; i++) {
  map[i] = 0;
}

let files = fs.readdirSync('data');
console.log(files);

for (let file of files) {
  const raw = fs.readFileSync(`data/${file}`, 'utf-8');
  const rows = raw.split('\n');
  for (let row of rows) {
    const data = row.split(',');
    const x = Math.floor(parseInt(data[0]) * scale);
    const y = Math.floor(parseInt(data[1]) * scale);
    const index = x + y * W;
    map[index]++;
  }
}

let out = '';
for (let x = 0; x < W; x++) {
  for (let y = 0; y < H; y++) {
    const index = x + y * W;
    let n = map[index];
    out += `${y},${x},${n}\n`;
  }
}
fs.writeFileSync('out.csv', out);

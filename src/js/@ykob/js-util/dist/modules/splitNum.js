const splitNum = (num) => {
    return String(Math.abs(Math.floor(num)))
        .split('')
        .map((o) => parseInt(o));
};
export default splitNum;
//# sourceMappingURL=splitNum.js.map
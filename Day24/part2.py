import sympy

xr, yr, zr, vxr, vyr, vzr = sympy.symbols("xr yr zr vxr vyr vzr")

def read_hailstones(filename):
    with open(filename, 'r') as file:
        return [tuple(map(int, line.replace("@", ",").split(","))) for line in file]

def solve_for_rock(hailstones):
    equations = []
    for i, (sx, sy, sz, vx, vy, vz) in enumerate(hailstones):
        equations.extend([
            (xr - sx) * (vy - vyr) - (yr - sy) * (vx - vxr),
            (yr - sy) * (vz - vzr) - (zr - sz) * (vy - vyr)
        ])
        if i >= 2:
            solutions = sympy.solve(equations, dict=True)
            answers = [soln for soln in solutions if all(x.is_Integer for x in soln.values())]
            if len(answers) == 1:
                return answers[0]

    return None

def main():
    hailstones = read_hailstones('input.txt')
    answer = solve_for_rock(hailstones)
    if answer:
        print(answer[xr] + answer[yr] + answer[zr])
    else:
        print("No solution found.")

if __name__ == "__main__":
    main()

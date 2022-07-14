package com;

public class LianLianKan {

    private static int n, m, x1, x2, y1, y2;

    private static boolean flag;

    private static boolean[][] validate;

    private static int[][] data;

    private static final int MAX_TURN = 2;

    private static boolean validate(int[][] board, Point a, Point b) {
        data = board;
        n = board.length;
        m = board[0].length;
        validate = new boolean[n][m];

        x1 = a.getX();
        y1 = a.getY();
        x2 = b.getX();
        y2 = b.getY();

        if (x1 == x2 && y1 == y2) {
            return false;
        }

        data[x1][y1] = 0;
        data[x2][y2] = 0;
        dfs(a.getX(), a.getY(), 0, 0);
        return flag;
    }

    private static void dfs(int x, int y, int turn, int dis) {
        if(x >= n || x < 0 || y >= m || y < 0 || data[x][y] != 0 || turn > MAX_TURN ||  validate[x][y]) {
            return ;
        }

        if (flag) {
            return;
        }

        if(x == x2 && y == y2) {
            flag = true;
            System.out.println("end x = " + x + ", y = " + y);
            return;
        }

        validate[x][y] = true;
        if(dis == 0) {
            dfs(x, y + 1, turn, 1);
            dfs(x + 1, y, turn, 2);
            dfs(x, y - 1, turn, 3);
            dfs(x - 1, y, turn, 4);
        }
        if(dis == 1) {
            dfs(x, y + 1, turn, 1);
            dfs(x + 1, y, turn + 1, 2);
            dfs(x, y - 1, turn + 1, 3);
            dfs(x - 1, y, turn + 1, 4);
        }
        if(dis == 2) {
            dfs(x + 1, y, turn, 2);
            dfs(x, y + 1, turn + 1, 1);
            dfs(x, y - 1, turn + 1, 3);
            dfs(x - 1, y, turn + 1, 4);
        }
        if(dis == 3) {
            dfs(x, y - 1, turn, 3);
            dfs(x, y + 1, turn + 1, 1);
            dfs(x + 1, y, turn + 1, 2);
            dfs(x - 1, y, turn + 1, 4);
        }
        if(dis == 4) {
            dfs(x - 1, y, turn, 4);
            dfs(x, y + 1, turn + 1, 1);
            dfs(x + 1, y, turn + 1, 2);
            dfs(x, y - 1, turn + 1, 3);
        }
        validate[x][y] = false;
    }

    public static void main(String[] args) {
        int[][] board = {
                {0, 0, 0, 0, 0},
                {0, 2, 3, 4, 0},
                {1, 2, 3, 5, 1}
        };
        boolean result = validate(board, new Point(2, 0), new Point(2,4));
        System.out.println(result);
    }

}


class Point {
    private int x;
    private int y;

    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public int getX() {
        return x;
    }

    public void setX(int x) {
        this.x = x;
    }

    public int getY() {
        return y;
    }

    public void setY(int y) {
        this.y = y;
    }
}

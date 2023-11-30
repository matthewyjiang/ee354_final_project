// Author: Matthew Jiang
// main.rs

// generate various map memory layouts and verify that there exists a path from the beginning to the end

use rand::prelude::*;
use std::fs::File;
use std::io::prelude::*;
fn main() {
    let map_x_size: usize = 30;
    let map_y_size: usize = 21;
    let starting_point = (0, 10);
    let ending_point = (29, 10);

    let mut map = vec![vec![0; map_y_size]; map_x_size];

    let num_obstacles = 150;

    let mut rng = rand::thread_rng();

    let mut obstacles_count = 0;

    while obstacles_count < num_obstacles {
        let x = rng.gen_range(0..map_x_size);
        let y = rng.gen_range(0..map_y_size);

        if map[x][y] == 0 && (x, y) != starting_point && (x, y) != ending_point {
            map[x][y] = 1;
            obstacles_count += 1;
        }
    }

    // find path and verify map is solvable using bfs algorithm

    let mut queue = Vec::new();
    let mut visited = vec![vec![false; map_y_size]; map_x_size];

    queue.push(starting_point);
    visited[starting_point.0][starting_point.1] = true;

    let mut solvable: bool = false;

    while !queue.is_empty() {
        let current = queue.remove(0);

        if current == ending_point {
            solvable = true;
            println!("Map is solvable");
            break;
        }

        let mut neighbors = Vec::new();

        if current.0 > 0 {
            neighbors.push((current.0 - 1, current.1));
        }
        if current.0 < map_x_size - 1 {
            neighbors.push((current.0 + 1, current.1));
        }
        if current.1 > 0 {
            neighbors.push((current.0, current.1 - 1));
        }
        if current.1 < map_y_size - 1 {
            neighbors.push((current.0, current.1 + 1));
        }

        for neighbor in neighbors {
            if map[neighbor.0][neighbor.1] == 0 && !visited[neighbor.0][neighbor.1] {
                queue.push(neighbor);
                visited[neighbor.0][neighbor.1] = true;
            }
        }
    }

    if solvable == true {
        // write map to txt file as 0s and 1s

        let mut map_string = String::new();

        for y in 0..map_y_size {
            for x in 0..map_x_size {
                map_string.push_str(&map[x][y].to_string());
                // map_string.push(' ');
            }
            map_string.push('\n');
        }

        let mut file = File::create("map.mem").expect("Error encountered while creating file!");
        file.write_all(map_string.as_bytes())
            .expect("Error encountered while writing to file!");
    } else {
        println!("Map is not solvable");
    }
}

import gymnasium as gym
import numpy as np
import matplotlib.pyplot as plt
from gymnasium.envs.toy_text.frozen_lake import generate_random_map

def train(env, q_table, alpha, gamma, epsilon, num_episodes):
    rewards = []
    for episode in range(num_episodes):
        state = env.reset()[0]
        total_reward = 0
        done = False

        
        while not done:
            if np.random.uniform() < epsilon:
                action = env.action_space.sample()
            else:
                action = np.argmax(q_table[state])
            
            next_state, reward, terminated, truncated, _ = env.step(action)
            done = terminated or truncated

            current_q = q_table[int(state), int(action)]
            next_max_q = np.max(q_table[next_state])
            new_q = (1 - alpha) * current_q + alpha * (reward + gamma * next_max_q)
            q_table[state, action] = new_q 
            
            state = next_state
            total_reward += reward
        
        rewards.append(total_reward)
        epsilon = max(epsilon - epsilon_decay, 0)  # Decrease exploration rate
        
        if (episode + 1) % 100 == 0:
            print(f"Episode {episode + 1}/{num_episodes}")

    print(q_table)
    
    return rewards

def visualize_solution(env, q_table):
    state, _ = env.reset()
    done = False
    
    while not done:
        action = np.argmax(q_table[state])
        state, _, terminated, truncated, _ = env.step(action)
        done = terminated or truncated
        env.render()
    
    env.close()

# Initialize environment
env = gym.make("FrozenLake-v1", is_slippery=False, desc=generate_random_map(size=8, p=0.90, seed=123), render_mode="human")

# Initialize Q-table
num_states = env.observation_space.n
num_actions = env.action_space.n
q_table = np.zeros((num_states, num_actions))

# Hyperparameters
alpha = 0.5
gamma = 0.85
epsilon = 1.0
epsilon_decay = 0.0001
num_episodes = 1

# Train the agent
rewards = train(env, q_table, alpha, gamma, epsilon, num_episodes)

# Visualize training progress
plt.plot(rewards)
plt.xlabel("Episode")
plt.ylabel("Total Reward")
plt.title("Training Progress")
plt.show()

# Visualize the agent's solution
visualize_solution(env, q_table)

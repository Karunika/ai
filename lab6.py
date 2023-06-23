import gymnasium as gym
import numpy as np
import matplotlib.pyplot as plt

def update_q_table(q_table, state, action, reward, next_state, alpha, gamma):
    current_q = q_table[state, action]
    next_max_q = np.max(q_table[next_state])
    new_q = (1 - alpha) * current_q + alpha * (reward + gamma * next_max_q)
    q_table[state, action] = new_q

def train(env, q_table, alpha, gamma, epsilon, num_episodes):
    rewards = []
    for episode in range(num_episodes):
        state = env.reset()
        total_reward = 0
        done = False
        
        while not done:
            if np.random.uniform() < epsilon:
                action = env.action_space.sample()
            else:
                action = np.argmax(q_table[state])
            
            next_state, reward, done, _ = env.step(action)
            update_q_table(q_table, state, action, reward, next_state, alpha, gamma)
            
            state = next_state
            total_reward += reward
        
        rewards.append(total_reward)
        epsilon *= 0.99  # Decrease exploration rate
        
        if (episode + 1) % 100 == 0:
            print(f"Episode {episode + 1}/{num_episodes}")
    
    return rewards

def visualize_solution(env, q_table):
    state = env.reset()
    done = False
    
    while not done:
        action = np.argmax(q_table[state])
        state, _, done, _ = env.step(action)
        env.render()
    
    env.close()

# Initialize environment
env = gym.make("FrozenLake-v1", map_name="8x8")

# Initialize Q-table
num_states = env.observation_space.n
num_actions = env.action_space.n
q_table = np.zeros((num_states, num_actions))

# Hyperparameters
alpha = 0.1
gamma = 0.99
epsilon = 1.0
num_episodes = 1000

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

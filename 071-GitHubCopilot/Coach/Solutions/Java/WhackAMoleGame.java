import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Random;

public class WhackAMoleGame extends JFrame {
    private JPanel panel;
    private JButton[] moles;
    private JLabel scoreLabel;
    private int score = 0;
    private Random random = new Random();

    public WhackAMoleGame() {
        setTitle("Whack-A-Mole");
        setSize(400, 400);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLayout(new BorderLayout());

        panel = new JPanel(new GridLayout(4, 4));
        moles = new JButton[16];
        for (int i = 0; i < moles.length; i++) {
            moles[i] = new JButton();
            moles[i].setEnabled(false);
            moles[i].addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    score++;
                    scoreLabel.setText("Score: " + score);
                }
            });
            panel.add(moles[i]);
        }
        add(panel, BorderLayout.CENTER);

        scoreLabel = new JLabel("Score: 0");
        add(scoreLabel, BorderLayout.SOUTH);

        new Timer(1000, new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                int index = random.nextInt(moles.length);
                for (JButton mole : moles) {
                    mole.setEnabled(false);
                    mole.setBackground(UIManager.getColor("Button.background")); // Reset to default color
                }
                moles[index].setEnabled(true);
                moles[index].setBackground(Color.RED); // Set the enabled mole's color to red
            }
        }).start();
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                final WhackAMoleGame game = new WhackAMoleGame();
                game.setVisible(true);

                // Timer to end the game after 10 seconds
                Timer endGameTimer = new Timer(10000, new ActionListener() {
                    @Override
                    public void actionPerformed(ActionEvent e) {
                        game.endGame();
                    }
                });
                endGameTimer.setRepeats(false); // Ensure the timer only runs once
                endGameTimer.start();
            }
        });
    }

    // Method to end the game
    public void endGame() {
        // Show a "Game Over" message
        JOptionPane.showMessageDialog(this, "Game Over", "Game Over", JOptionPane.INFORMATION_MESSAGE);
    }
}
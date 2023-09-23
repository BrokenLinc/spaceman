using Godot;
using System;

public class Player : CharacterBody2D {
    public float Speed = Globals.PlayerBaseSpeed;
    private Tween InjuryTween;
    
    [Export]
    private NodePath HealthBarPath;
    private ProgressBar HealthBar;
    private NodePath Sprite2DPath;
    private Sprite Sprite2D;
    private NodePath InjurySoundPath;
    private AudioStreamPlayer InjurySound;
    
    public override void _Ready() {
        HealthBar = GetNode<ProgressBar>(HealthBarPath);
        Sprite2D = GetNode<Sprite>(Sprite2DPath);
        InjurySound = GetNode<AudioStreamPlayer>(InjurySoundPath);
    }

    public override void _PhysicsProcess(float delta) {
        var direction = new Vector2(
            Input.GetActionStrength("right") - Input.GetActionStrength("left"),
            Input.GetActionStrength("down") - Input.GetActionStrength("up")
        );
        
        Velocity = direction * Speed;
        MoveAndSlide();
        Globals.PlayerPosition = Position;

        if (Math.Abs(direction.x) > 0) {
            Sprite2D.FlipH = direction.x < 0;
        }
    }

    private void OnMagnetBodyEntered(Node body) {
        (body as Item)?._OnMagnetized();
    }

    private void OnPickupBodyEntered(Node body) {
        (body as Item)?._OnPickup();
    }

    public void UpdateHealthBar() {
        HealthBar.MaxValue = Globals.PlayerMaxHealth;
        HealthBar.Value = Globals.PlayerHealth;
    }

    public void TakeDamage(int damage) {
        InjuryTween?.StopAll();
        InjuryTween = GetTree().CreateTween();

        Sprite2D.Modulate = new Color(1.0f, 0, 0);
        InjuryTween.InterpolateProperty(Sprite2D, "modulate", new Color(1.0f, 0, 0), new Color(1.0f, 1.0f, 1.0f), 0.2f);
        
        InjurySound.Play();
    }
}
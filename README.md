# Triangular-Pixels-Shader
Shader and c# script for unity 2019.4 (2020 doesn't run well on my pc) which makes screen pixels triangular. "Send random" button on the ReplaceShader c# script should offset the corners of the triangles randomly. Open to recommendations for optimization.

Set up by attaching "ReplaceShader.cs" to a camera in Unity and setting up the public variables like this:

[Effect Material] : CameraMaterial <- the material from this repository should already be set up with the correct shader

[Send Aspect] : true <- sends the aspect ratio to the shader

[Send Random] : false <- click this after running the editor build to randomize the triangles

[X Size] : _SizeX <- lets shader use aspect ratio to make all of the triangles "square" regardless of screen shape

[Y Size] : _SizeY

[Random Array] : _Random <- array of random numbers by which to offset triangles

[Size] : somewhere around 0.1 <- size of triangles relative to screen, shader takes a >1 exponent of this to make the slider easier to adjust for smaller values

[Cam] : Camera (Camera) <- camera object that script is attached to

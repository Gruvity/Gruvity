#requires -Module PSSVG

$AssetsPath = $PSScriptRoot | Split-Path | Join-Path -ChildPath "Assets"

if (-not (Test-Path $AssetsPath)) {
    New-Item -ItemType Directory -Path $AssetsPath | Out-Null
}

function ⇴ {
    param($radius, $angle)
    $radius * [math]::round([math]::cos($angle * [Math]::PI/180),15)
    $radius * [math]::round([math]::sin($angle * [Math]::PI/180),15)
}

$fontName = 'Anta'
$fontName = 'Heebo'
$fontName = 'Noto Sans'

svg -content $(
    $commonParameters = [Ordered]@{
        Fill        = '#4488FF'
        Class       = 'foreground-fill'
    }

    SVG.GoogleFont -FontName $fontName

    svg.symbol -Id psChevron -Content @(
        svg.polygon -Points (@(
            "40,20"
            "45,20"
            "60,50"
            "35,80"
            "32.5,80"
            "55,50"
        ) -join ' ')
    ) -ViewBox 100, 100

    $radius = 420
    
    $circleTop    = (1080/2), ((1080/2)-$radius)
    $circleMid    = (1080/2), (1080/2)
    $circleRight  = ((1080/2) + $radius),((1080/2))
    $circleBottom = (1080/2), ((1080/2)+$radius)
    $circleLeft   = ((1080/2) - $radius),((1080/2))    
    
    svg.use -Href '#psChevron' -X 0% -Y 37.5% @commonParameters -Height 25% -Opacity .9

    $arcStart  = ⇴ $radius 45 100
    $arcEnd    = ⇴ $radius 135 100 
    
    SVG.ArcPath -Start $circleLeft -End $circleRight  -Radius $radius -Stroke 'transparent' -Id 'arc2' -Fill 'transparent'
    
    SVG.Circle -Cx (1080/2) -Cy (1080/2) -R ($radius*1.2) -Fill transparent -Stroke '#4488FF' -StrokeWidth 1% -Class 'foreground-stroke'
    SVG.Circle -Cx (1080/2) -Cy (1080/2) -R ($radius*0.3) -Fill transparent -Stroke '#4488FF' -StrokeWidth 1% -Class 'foreground-stroke'

    svg.text -X 64% -FontSize 8.4em @commonParameters -DominantBaseline 'middle' -Style "font-family:'$fontName'" -TextAnchor 'middle' @(        
        SVG.textPath -Href '#arc2' -Content "Gruvity"
    ) -LetterSpacing .3em   
    
    # be the change you want to see in the world - esse mutationem vis videre in mundo
    SVG.animateTransform -AttributeName 'transform' -Type 'rotate' -Values "0;360" -Dur 4.2s -RepeatCount 'indefinite'
) -ViewBox 0, 0, 1080, 1080 -TransformOrigin '50% 50%' -OutputPath $(
    Join-Path $assetsPath Gruvity.svg
)

Hello,

Welcome to Blue Lego Framework. This project is based on Reflex
(http://github.com/reflex) and is still verry exparimental. The core idea behind
Blue Lego is that all components are made up of "LegoBlock" and you apply behaviors
to define functionality. Here is a quick example of how this would work.

LogoBlock Button Example:

<lego:LegoBlock styleID="demoButton" spriteSheet="{spriteSheetManager}">
    <lego:behaviors>
        <lego:StyleBehavior styleSheet="{styleSheet}"/>
        <rx:ButtonBehavior></rx:ButtonBehavior>
    </lego:behaviors>
</lego:LegoBlock>

As you can see here in order to make a simple button we start with a lego block
then add the ButtonBehavior from Reflex to make it behave like a traditional button
component. Likewise we can add Styling (via F*CSS) with the StyleBehavior.

I will continue to make more behaviors and documentation as I flesh out the
framework.
local HandLogicHelper = {}

function isPlayerTurn(player, dealer)
    player.isTurn = not dealer.isDealing
end
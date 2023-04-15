--엘리바가르 미스트플라워
function c112000004.initial_effect(c)
    --개방 영속 효과
    cyan.SetUnlockedEffect(c,c112000004.unlockeff)
end

function c112000004.unlockeff(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
    e1:SetOperation(c112000004.keyop)
    Duel.RegisterEffect(e1,tp)
end
function c112000004.keyop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local num=0
    for i=1,9 do
        if Duel.SelectYesNo(tp,aux.Stringid(112000004,i)) then
            num=i
            break
        end
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAIN_SOLVING)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e1:SetOperation(c112000004.makeop)
    e1:SetLabel(num)
    Duel.RegisterEffect(e1,tp)
end
function c112000004.makeop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
    if ct==0 then return end
    ct=ct-1
    if ct==0 then
        Duel.ChangeChainOperation(ev,c112000004.repop(tp))
    end
    e:SetLabel(ct)
end
function c112000004.repop(p)
    return function(e,tp,eg,ep,ev,re,r,rp)
        Duel.Draw(p,1,REASON_EFFECT)
    end
end
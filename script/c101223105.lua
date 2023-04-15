--퓨전 서포터
local tcname,tclv
function c101223105.initial_effect(c)
	c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,2,2)
	--링크 소재로 쓸 수 없다.
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
	--토큰 소환
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(101223105,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1,101223105)
	e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c101223105.coscost)
	e2:SetTarget(c101223105.costarget)
	e2:SetOperation(c101223105.cosoperation)
    c:RegisterEffect(e2)
	--융합 소환 성공시 1드로
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(101223105,2))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101223905)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(c101223105.drcon)
    e3:SetTarget(c101223105.drtg)
    e3:SetOperation(c101223105.drop)
    c:RegisterEffect(e3)
end
--1번 관련 효과
function c101223105.filter1(c,tp)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:GetOriginalLevel()>0
end
function c101223105.coscost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c101223105.filter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,tp) 
	end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local cg=Duel.SelectMatchingCard(tp,c101223105.filter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
    Duel.Remove(cg,REASON_COST)
    e:SetLabel(cg:GetFirst():GetCode())
	tcname=e:GetLabel()
	e:SetLabel(cg:GetFirst():GetOriginalLevel())
	tclv=e:GetLabel()
end
function c101223105.costarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,101223105)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsPlayerCanSpecialSummonMonster(tp,101223106,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c101223105.cosoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101223106,0,TYPES_TOKEN_MONSTER,-2,0,0,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,101223106)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tcname)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(tclv)
		token:RegisterEffect(e2)		
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(89312388,1))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCountLimit(1)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetLabelObject(e1)
		e3:SetOperation(c101223105.rstop)
		token:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
function c101223105.drcon(e,tp,eg,ep,ev,re,r,rp)
    local tg=eg:GetFirst()
    return eg:GetCount()==1 and tg~=e:GetHandler() and tg:IsSummonType(SUMMON_TYPE_FUSION)
end
function c101223105.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101223105.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c101223105.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=e:GetLabelObject()
    e1:Reset()
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
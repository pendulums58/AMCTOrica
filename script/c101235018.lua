--컨티뉴∞
c101235018.AccessMonsterAttribute=true
function c101235018.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c101235018.afil1,c101235018.afil2)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c101235018.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101235018.negcon)
	e2:SetCost(c101235018.cost)
	e2:SetOperation(c101235018.remop)
	c:RegisterEffect(e2)
	--어드민 덤핑
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101235018.tdcon)
	e3:SetOperation(c101235018.adop)
	c:RegisterEffect(e3)
end
function c101235018.afil1(c)
	local rc=Duel.ReadCard(c,CARDDATA_SETCODE)
	return rc>0 and c:IsType(TYPE_MONSTER)
end
function c101235018.afil2(c)
	return c:IsType(TYPE_MONSTER)
end
function c101235018.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK or se:GetHandler():IsCode(101235018)
end
function c101235018.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetAdmin()==nil
end
function c101235018.filter(c)
	return c:IsAbleToDeckAsCost()
end
function c101235018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101235018.filter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c101235018.filter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c101235018.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101235018.tdcon(e,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	local ad=e:GetHandler():GetAdmin()
	return Duel.IsExistingMatchingCard(nil,c:GetControler(),LOCATION_REMOVED,0,10,nil) and ad
end
function c101235018.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	if ad then
		Duel.SendtoGrave(ad,REASON_EFFECT)
	end
end
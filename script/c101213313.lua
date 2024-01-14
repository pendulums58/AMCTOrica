--시계탑의 지배자
function c101213313.initial_effect(c)
	--싱크로 소환
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,nil,2,2,c101213313.sfilter,1,1)
	--드로우
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101213313.drcon)
	e1:SetTarget(c101213313.drtg)
	e1:SetOperation(c101213313.drop)
	c:RegisterEffect(e1)
	--필드의 카드 파괴
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101213313,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c101213313.destg)
	e2:SetOperation(c101213313.desop)
	c:RegisterEffect(e2)
	--개♡♡♡♡♡♡♡♡껄리는♡♡♡♡♡♡♡♡♡♡해깃♡♡♡♡♡♡♡♡♡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101213313,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(c101213313.hptg)
	e3:SetOperation(c101213313.hpop)
	c:RegisterEffect(e3)	
end
function c101213313.sfilter(c)
	return c:GetLevel()==5 and c:IsSetCard(0x60a)
end
function c101213313.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c101213313.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,75041269)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c101213313.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,75041269)
	Duel.Draw(p,ct,REASON_EFFECT)
end
function c101213313.desfilter(c)
	return c:GetLevel()>0 or c:GetRank()>0
end
function c101213313.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101213313.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,75041269) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101213313.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101213313.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if not Duel.Destroy(tc,REASON_EFFECT)~=0 then return end
		local ct=tc:GetLevel()
		if tc:IsType(TYPE_XYZ) then ct=tc:GetRank() end
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_FZONE,0,1,1,nil,75041269)
		if g:GetCount()>0 then
			tc1=g:GetFirst()
			tc1:AddCounter(0x1b,ct)
		end		
	end
end
function c101213313.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101213313.hptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101213313.filter,tp,LOCATION_FZONE,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c101213313.filter,tp,LOCATION_FZONE,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c101213313.hpop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c101213313.filter,tp,LOCATION_FZONE,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end


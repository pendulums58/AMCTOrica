--스타더스트 서포터
function c103557001.initial_effect(c)
	--엑시즈 소재 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(103557001,0))
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,103557001)
	e2:SetCost(cyan.dhcost(1))
	e2:SetTarget(c103557001.thtg)
	e2:SetOperation(c103557001.thop)
	c:RegisterEffect(e2)
	--레벨 변경
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(103557001,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c103557001.lvtg)
	e3:SetOperation(c103557001.lvop)
	c:RegisterEffect(e3)	
	--묘지 효과
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(84012625)
	e4:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e4)	
	if not c103557001.global_check then
		c103557001.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c103557001.checkop)
		Duel.RegisterEffect(ge1,0)
	end	
end
function c103557001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103557001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c103557001.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c103557001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(g,1-tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCondition(c103557001.athcon)
		e1:SetTarget(c103557001.athtg)
		e1:SetOperation(c103557001.athop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c103557001.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa3) and c:IsAbleToHand()
end
function c103557001.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSummonType(SUMMON_TYPE_SYNCHRO) and tc:IsSetCard(0xa3) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),103557001,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c103557001.athtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103557001.thfilter1,tp,LOCATION_DECK,0,1,nil) end
end
function c103557001.athop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(103557001,2)) then
		local g=Duel.SelectMatchingCard(tp,c103557001.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(g,1-tp)
		end
	end
end
function c103557001.thfilter1(c)
	return c:IsSetCard(0xa3) and c:IsAbleToHand()
end
function c103557001.athcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and eg:IsExists(c103557001.thck,1,nil) and Duel.GetFlagEffect(tp,103557001)==1
end
function c103557001.thck(c)
	return c:IsSetCard(0xa3) and c:GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c103557001.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLevelAbove(1) and not c:IsLevel(7) end
end
function c103557001.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(7)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
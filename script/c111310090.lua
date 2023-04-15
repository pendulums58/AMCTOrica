--위시 큐레이터
function c111310090.initial_effect(c)
	--싱크로 소환
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_ACCESS),1)
	c:EnableReviveLimit()	
	--싱크로 소환 성공시
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310090,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c111310090.con)
	e1:SetTarget(c111310090.tg)
	e1:SetOperation(c111310090.op)
	c:RegisterEffect(e1)
	--어드민으로 한다
	local e2-=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c111310090.adtg)
	e2:SetOperation(c111310090.adop)
	c:RegisterEffect(e2)
end
function c111310090.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c111310090.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local sel=0
	local op=2
	if Duel.IsPlayerCanDraw(tp,1) then sel=sel+1 end
	if Duel.IsExistingMatchingCard(c111310090.filter,tp,LOCATION_DECK,0,1,nil) then sel=sel+2 end
	if sel==3 then
		op=Duel.SelectOption(tp,aux.Stringid(111310090,2),aux.Stringid(111310090,0),aux.Stringid(111310090,1))
	elseif sel==2 then
		op=Duel.SelectOption(aux.Stringid(111310090,2),aux.Stringid(111310090,1))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(111310090,0),aux.Stringid(111310090,1))+1
	end
	if op==2 then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,3000)
		e:SetLabel(2)
	elseif (op==0 or (sel==2 and op==1)) then 
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		e:SetLabel(1)
	else
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		e:SetLabel(0)
	end
end
function c111310090.filter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x606)
end
function c111310090.op(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==2 then
		Duel.Recover(tp,3000,REASON_EFFECT)
	end
	if op==1 then
		local g=Duel.SelectMatchingCard(tp,c111310090.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end	
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c111310090.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsType(TYPE_ACCESS) and chkc:IsControler(tp) and chkc:GetAdmin()==nil end
	if chk==0 then return Duel.IsExistingTarget(c111310090.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c111310090.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c111310090.tgfilter(c)
	return c:IsType(TYPE_ACCESS) and c:GetAdmin()==nil and c:IsFaceup()
end
function c111310090.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and tc:GetAdmin()==nil then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
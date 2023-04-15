--영생하는 뱀
c111310113.AccessMonsterAttribute=true
function c111310113.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310113.afilter1,aux.TRUE)
	c:EnableReviveLimit()	
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310113,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c111310113.destg)
	e1:SetOperation(c111310113.desop)
	c:RegisterEffect(e1)
	--부활
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c111310113.regcon1)
	e3:SetOperation(c111310113.regop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(111310113,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCondition(c111310113.spcon2)
	e4:SetTarget(c111310113.sptg2)
	e4:SetOperation(c111310113.spop2)
	c:RegisterEffect(e4)
end
function c111310113.afilter1(c)
	return c:GetSummonLocation()==LOCATION_GRAVE
end
function c111310113.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and ad and tc:IsAttribute(ad:GetAttribute()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c111310113.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then Duel.Destroy(g,REASON_EFFECT) end
end
function c111310113.regcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY)
end
function c111310113.regop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(111310113,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c111310113.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(111310113)>0
end
function c111310113.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c111310113.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,TYPE_MONSTER)
				and Duel.SelectYesNo(tp,aux.Stringid(111310113,0)) then
				local ad=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c,TYPE_MONSTER)
				if ad:GetCount()>0 then
					ad=ad:GetFirst()
					Duel.SetAdmin(c,ad,e)
				end
				
			end
		end
	end
end
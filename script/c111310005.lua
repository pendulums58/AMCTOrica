--브루트포스 댄서
c111310005.AccessMonsterAttribute=true
function c111310005.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE)
	c:EnableReviveLimit()
	--브루트포싱
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c111310005.con)
	e1:SetTarget(c111310005.thtg)
	e1:SetOperation(c111310005.thop)
	c:RegisterEffect(e1)
	--물 속성 파괴내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c111310005.filter)
	e2:SetValue(1)
	c:RegisterEffect(e2)	
end
function c111310005.afil1(c)
	return true
end
function c111310005.afil2(c)
	return true
end
function c111310005.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ACCESS
end
function c111310005.filter(e,c)
	local ad=e:GetHandler():GetAdmin()
	if ad then return ad:GetRace()==c:GetRace() end
	return false
end
function c111310005.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c111310005.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,POS_FACEUP,REASON_EFFECT)==0 then
			Duel.Damage(1-tp,800,REASON_EFFECT)
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 then
				local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
				if g:GetCount()>0 then
					local sg=g:RandomSelect(1-tp,1)
					Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
					Duel.SendtoGrave(tc,REASON_EFFECT)
				end
			end
		end
	end
end
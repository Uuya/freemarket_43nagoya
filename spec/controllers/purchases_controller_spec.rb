require 'rails_helper'

describe PurchasesController do
  let(:user) { create(:user, id: 44) }

  describe 'GET #show' do

    context 'log in' do
      before do
        login(user)
      end

      it 'renders the :show template' do
        product = create(:product)
        get :show, params: { id: product.id }
        expect(response).to render_template :show
      end
    end

    context 'not log in' do
      it 'redirects to user_session_path' do
        product = create(:product)
        get :show, params: { id: product.id }
        expect(response).to redirect_to(user_session_path)
      end
    end

  end

  describe 'POST #update' do

    context 'log in' do
      before do
        login(user)
      end

      it 'buy product' do
        product = create(:product)
        patch :update, params: { id: product.id, buyer_id: 1 }
        allow(Payjp::Charge).to receive(:create).and_return(PayjpMock.prepare_valid_charge)
      end
    end

    context 'not log in' do
      it 'redirects to user_session_path' do
        product = create(:product)
        patch :update, params: { id: product.id, buyer_id: 1 }
        expect(response).to redirect_to(user_session_path)
      end
    end

  end

end

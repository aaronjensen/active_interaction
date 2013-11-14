require 'spec_helper'

describe ActiveInteraction::MethodMissing do
  let(:model) do
    Class.new do
      include ActiveInteraction::MethodMissing
    end
  end

  subject(:instance) { model.new }

  describe '#method_missing' do
    context 'with invalid slug' do
      let(:slug) { :slug }

      it 'calls super' do
        expect {
          instance.method_missing(slug)
        }.to raise_error NoMethodError
      end
    end

    context 'with valid slug' do
      let(:filter) { ActiveInteraction::Filter.factory(slug) }
      let(:slug) { :boolean }

      it 'yields' do
        expect { |b|
          instance.method_missing(slug, &b)
        }.to yield_with_args(filter, [], {})
      end

      context 'with names' do
        let(:names) { [:a, :b, :c] }

        it 'yields' do
          expect { |b|
            instance.method_missing(:boolean, *names, &b)
          }.to yield_with_args(filter, names, {})
        end
      end

      context 'with options' do
        let(:options) { { a: nil, b: false, c: true } }

        it 'yields' do
          expect { |b|
            instance.method_missing(:boolean, options, &b)
          }.to yield_with_args(filter, [], options)
        end
      end

      context 'with names & options' do
        let(:names) { [:a, :b, :c] }
        let(:options) { { a: nil, b: false, c: true } }

        it 'yields' do
          expect { |b|
            instance.method_missing(:boolean, *names, options, &b)
          }.to yield_with_args(filter, names, options)
        end
      end
    end
  end
end

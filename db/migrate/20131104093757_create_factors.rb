class CreateFactors < ActiveRecord::Migration
  def change
    create_table :factors do |t|
      t.references :branch, index: true
      t.references :user, index: true
      t.integer :month
      t.integer :year
      t.float :prepay
      t.integer :avaragebill
      t.float :clients
      t.float :weight
      t.float :incomes
      t.float :prolongcent
      t.float :proplancor
      t.float :planproc04from
      t.float :planproc04to
      t.float :planproc06from
      t.float :planproc06to
      t.float :planproc08from
      t.float :planproc08to
      t.float :planproc10from
      t.float :planproc10to
      t.float :planproc12from
      t.float :planproc12to

      t.timestamps
    end
  end
end

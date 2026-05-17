using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.AHS;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.PhucTham.BanAn
{
    public partial class pChonHinhPhat : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal BanAnSoThamID = 0, BiCaoID = 0, ToiDanhID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            BanAnSoThamID = (string.IsNullOrEmpty(Request["aID"] + "")) ? 0 : Convert.ToDecimal(Request["aID"] + "");
            BiCaoID = (string.IsNullOrEmpty(Request["bID"] + "")) ? 0 : Convert.ToDecimal(Request["bID"]);
            ToiDanhID = (string.IsNullOrEmpty(Request["tID"] + "")) ? 0 : Convert.ToDecimal(Request["tID"]);
            if (!IsPostBack)
            {
                LoadInfo();
            }
        }
        void LoadInfo()
        {
            AHS_BICANBICAO objBc = dt.AHS_BICANBICAO.Where(x => x.ID == BiCaoID).Single<AHS_BICANBICAO>();
            if (objBc != null) lttTenBiCao.Text = objBc.HOTEN;

            DM_BOLUAT_TOIDANH obj = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == ToiDanhID).Single<DM_BOLUAT_TOIDANH>();
            
            if (obj != null)
            {
                lttToiDanh.Text = obj.TENTOIDANH;
                AHS_PHUCTHAM_BANAN_DIEU_CT_BL objHP = new AHS_PHUCTHAM_BANAN_DIEU_CT_BL();
                DataTable tbl = objHP.GetAllHinhPhatByDK(BanAnSoThamID, BiCaoID, ToiDanhID);
                if (tbl != null)
                {
                    rptHP.DataSource = tbl;
                    rptHP.DataBind();
                }              
            }
        }

        protected void rptHP_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                CheckBox chk = (CheckBox)e.Item.FindControl("chk");
                int IsChange = (String.IsNullOrEmpty(rv["IsChange"] + "")) ? 0 : Convert.ToInt16( rv["IsChange"].ToString());
                if (IsChange > 0)
                    chk.Checked = true;

                HiddenField hddLoai = (HiddenField)e.Item.FindControl("hddLoai");
                int loai = Convert.ToInt32(hddLoai.Value);
                switch (loai)
                {
                    case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                        RadioButtonList rdTrueFalse = (RadioButtonList)e.Item.FindControl("rdTrueFalse");
                        rdTrueFalse.Visible = true;
                        rdTrueFalse.SelectedValue = (String.IsNullOrEmpty(rv["TF_value"] + "")) ? "0" : rv["TF_value"].ToString();
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                        TextBox txtSohoc = (TextBox)e.Item.FindControl("txtSohoc");
                        txtSohoc.Visible = true;
                        txtSohoc.Text = (String.IsNullOrEmpty(rv["SH_Value"] + "")) ? "0" : rv["SH_Value"].ToString();
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                        Panel pnThoiGian = (Panel)e.Item.FindControl("pnThoiGian");
                        pnThoiGian.Visible = true;

                        TextBox txtNam = (TextBox)e.Item.FindControl("txtNam");
                        txtNam.Text = (String.IsNullOrEmpty(rv["TG_Nam_Tu"] + "")) ? "0" : rv["TG_Nam_Tu"].ToString();

                        TextBox txtThang = (TextBox)e.Item.FindControl("txtThang");
                        txtThang.Text = (String.IsNullOrEmpty(rv["TG_Thang_Tu"] + "")) ? "0" : rv["TG_Thang_Tu"].ToString();

                        TextBox txtNgay = (TextBox)e.Item.FindControl("txtNgay");
                        txtNgay.Text = (String.IsNullOrEmpty(rv["TG_Ngay_Tu"] + "")) ? "0" : rv["TG_Ngay_Tu"].ToString();
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                        Panel pnKhac = (Panel)e.Item.FindControl("pnKhac");
                        pnKhac.Visible = true;

                        TextBox txtKhac1 = (TextBox)e.Item.FindControl("txtKhac1");
                        txtKhac1.Text = (String.IsNullOrEmpty(rv["K_Value1"] + "")) ? "0" : rv["K_Value1"].ToString();

                        TextBox txtKhac2 = (TextBox)e.Item.FindControl("txtKhac2");
                        txtKhac2.Text = (String.IsNullOrEmpty(rv["K_Value2"] + "")) ? "0" : rv["K_Value2"].ToString();
                        break;
                }
            }
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            int loai = 0;
            Boolean IsUpdate = false;
            Decimal HinhPhatID = 0;
            AHS_PHUCTHAM_BANAN_DIEU_CT obj = null;
            String OldItem = "|", temp ="", DelItem = "|"; 
            //-----------Lay ds cac muc toi danh cu-------------------
            try
            {
                List<AHS_PHUCTHAM_BANAN_DIEU_CT> lst = dt.AHS_PHUCTHAM_BANAN_DIEU_CT.Where(x => x.BANANID == BanAnSoThamID
                                                                                                   && x.BICANID == BiCaoID
                                                                                                   && x.TOIDANHID == ToiDanhID).ToList();
                if (lst != null && lst.Count > 0)
                {
                    foreach (AHS_PHUCTHAM_BANAN_DIEU_CT objCT in lst)
                    {
                        if (OldItem.Length > 1)
                            OldItem += "|";
                        OldItem += objCT.HINHPHATID.ToString();
                    }
                }
            }catch(Exception ex) { }
            
            //------------------------------
            foreach (RepeaterItem item in rptHP.Items)
            {
                CheckBox chk = (CheckBox)item.FindControl("chk");
                HiddenField hddLoai = (HiddenField)item.FindControl("hddLoai");
                loai = Convert.ToInt32(hddLoai.Value);

                HiddenField hddHinhPhatID = (HiddenField)item.FindControl("hddHinhPhatID");
                HinhPhatID = Convert.ToInt32(hddHinhPhatID.Value);
                temp = "|" + HinhPhatID + "|";
                if (!chk.Checked)
                {
                    if (OldItem.Contains(temp))
                    {
                        if (DelItem.Length > 1)
                            DelItem += "|";
                        DelItem += HinhPhatID.ToString();                        
                    }
                }

                //---------------------
                try
                {
                    IsUpdate = false;
                    obj = dt.AHS_PHUCTHAM_BANAN_DIEU_CT.Where(x => x.BANANID == BanAnSoThamID
                                                                   && x.BICANID == BiCaoID
                                                                   && x.HINHPHATID == HinhPhatID
                                                                   && x.TOIDANHID == ToiDanhID).Single<AHS_PHUCTHAM_BANAN_DIEU_CT>();
                    if (obj != null)
                        IsUpdate = true;
                    else obj = new AHS_PHUCTHAM_BANAN_DIEU_CT();
                }
                catch (Exception ex) { obj = new AHS_PHUCTHAM_BANAN_DIEU_CT(); }

                obj.LOAIHINHPHAT = loai;
                obj.ISCHANGE = 0;
                obj.TF_VALUE = obj.SH_VALUE = obj.TG_NAM = obj.TG_THANG = obj.TG_NGAY = 0;
                obj.K_VALUE1 = 0;
                obj.K_VALUE2 = "";

                if (chk.Checked)
                {
                    switch (loai)
                    {
                        case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                            RadioButtonList rdTrueFalse = (RadioButtonList)item.FindControl("rdTrueFalse");
                            obj.TF_VALUE = Convert.ToDecimal(rdTrueFalse.SelectedValue);
                            break;
                        case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                            TextBox txtSohoc = (TextBox)item.FindControl("txtSohoc");
                            obj.SH_VALUE = (String.IsNullOrEmpty(txtSohoc.Text + "")) ? 0 : Convert.ToDecimal(txtSohoc.Text);
                            break;
                        case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                            Panel pnThoiGian = (Panel)item.FindControl("pnThoiGian");

                            TextBox txtNam = (TextBox)item.FindControl("txtNam");
                            obj.TG_NAM = (String.IsNullOrEmpty(txtNam.Text + "")) ? 0 : Convert.ToDecimal(txtNam.Text);

                            TextBox txtThang = (TextBox)item.FindControl("txtThang");
                            obj.TG_THANG = (String.IsNullOrEmpty(txtThang.Text + "")) ? 0 : Convert.ToDecimal(txtThang.Text);

                            TextBox txtNgay = (TextBox)item.FindControl("txtNgay");
                            obj.TG_NGAY = (String.IsNullOrEmpty(txtNgay.Text + "")) ? 0 : Convert.ToDecimal(txtNgay.Text); ;
                            break;
                        case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                            Panel pnKhac = (Panel)item.FindControl("pnKhac");

                            TextBox txtKhac1 = (TextBox)item.FindControl("txtKhac1");
                            obj.K_VALUE1 = (String.IsNullOrEmpty(txtKhac1.Text + "")) ? 0 : Convert.ToDecimal(txtKhac1.Text);
                            TextBox txtKhac2 = (TextBox)item.FindControl("txtKhac2");
                            obj.K_VALUE2 = (String.IsNullOrEmpty(txtKhac2.Text + "")) ? "" : txtKhac2.Text.Trim();
                            break;
                    }
                    obj.ISCHANGE = 1;
                }
                else
                    obj.ISCHANGE = 0;
                if (!IsUpdate)
                {
                    obj.BANANID = BanAnSoThamID;
                    obj.BICANID = BiCaoID;
                    obj.TOIDANHID = ToiDanhID;
                    obj.HINHPHATID = HinhPhatID;
                    dt.AHS_PHUCTHAM_BANAN_DIEU_CT.Add(obj);                    
                }
                dt.SaveChanges();
                lttMsg.Text = "Lưu hình phạt thành công!";
            }
        }
    }
}
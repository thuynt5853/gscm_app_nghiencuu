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
using BL.GSTP.GDTTT;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class pNguoiKN : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        String UserName = "";
        public decimal VuAnID = 0;
        public int nguoikhieunai = 2;
        public int bicao = 0;
        public int bcdauvu = 1;
        public String type = "";
        public decimal CurrNhomNSDID = 0;
        decimal don_id = 0;
        Decimal GetDonID()
        {
            string current_id = Request["hsID"] + "";
            if (current_id == "0")
            {
                don_id = Convert.ToDecimal(Session["VUVIECID_CC"] + "");
            }
            else
            {
                don_id = Convert.ToDecimal(current_id);
            }
            return don_id;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDropNguoiKhieuNai();
                LoadDropBiCao();
                LoadDanhSachBiCao();
                GetDonID();
                if (Request["DS_ID"] + "" != "")
                {
                    LoadThongTinBC_AHS(Convert.ToDecimal(Request["DS_ID"] + ""));
                    hddBiCaoID.Value = (Request["DS_ID"] + "");
                }
            }
        }

        protected void dropNguoiKhieuNai_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropNguoiKhieuNai.SelectedValue == "-1")
            {
                pnNguoiKN.Visible = true;
                //Them moi nguoi khieu nai khong phai la bi cao

            }
            else
            {
                pnNguoiKN.Visible = false;
                Decimal vNguoiKN_ID = Convert.ToDecimal(dropNguoiKhieuNai.SelectedValue);
                //Kiểm tra xem ngươi khieu nai da tao co phải la bi cao khong

            }
            
        }
        void LoadDropNguoiKhieuNai()
        {
            Decimal CurrVuAnID = GetDonID(); 
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();

            dropNguoiKhieuNai.Items.Clear();
            dropNguoiKhieuNai.Items.Add(new ListItem("-----Chọn-----", "0"));
            DataTable tbl = objBL.AHS_GetAllByLoaiDS(CurrVuAnID, 3);// Lay ra nguoi khieu nai va bi cao
            if (tbl != null && tbl.Rows.Count > 0)
            {
                string temp = "", tucachtt_khac = "";
                foreach (DataRow item in tbl.Rows)
                {
                    temp = item["TenDuongSu"] + "";
                    if (Convert.ToDecimal(item["HS_BiCanDauVu"]) == 1 || Convert.ToDecimal(item["HS_IsBiCao"]) == 1)
                        tucachtt_khac = "(Bị cáo)";
                    else
                        tucachtt_khac = "(Người KN)";
                    //tucachtt_khac = (string.IsNullOrEmpty(item["DuongSu_TuCachToTung"] + "") ? "" : (" (" + item["DuongSu_TuCachToTung"] + ")"));
                    if (!temp.Contains(tucachtt_khac))
                        temp += tucachtt_khac;
                    dropNguoiKhieuNai.Items.Add(new ListItem(temp, item["ID"].ToString()));
                }
                dropNguoiKhieuNai.Items.Add(new ListItem("----------Thêm mới người KN-------","-1"));
            }
        }

        void LoadDropBiCao()
        {
            Decimal vuan_id = 0;
            //----------------
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = new DataTable();
            vuan_id = GetDonID();
            tbl = objBL.AHS_GetAllByLoaiDS(vuan_id, bicao);
            //--------------------
            dropBiCao.Items.Clear();
            dropBiCao.Items.Add(new ListItem("-----Chọn bị cáo-----", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                string temp = "", tucachtt_khac = "";
                foreach (DataRow item in tbl.Rows)
                {
                    temp = item["TenDuongSu"] + "";
                    if (Convert.ToDecimal(item["HS_BiCanDauVu"]) == 1 || Convert.ToDecimal(item["HS_IsBiCao"]) == 1)
                        tucachtt_khac = "(Bị cáo)";
                    //tucachtt_khac = (string.IsNullOrEmpty(item["HS_TuCachToTung"] + "") ? "" : (" (" + item["HS_TuCachToTung"] + ")"));
                    if (!temp.Contains(tucachtt_khac))
                        temp += tucachtt_khac;
                    dropBiCao.Items.Add(new ListItem(temp, item["ID"].ToString()));
                }
            }
        }

        void Update_DuongSu_AnHS( Decimal DuongSuID)
        {
            don_id = GetDonID();           
            //------------------------------
            DuongSuID = Convert.ToDecimal(hddBiCaoID.Value);
            GDTTT_VUAN_DUONGSU obj = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == DuongSuID && x.VUANID == don_id).Single<GDTTT_VUAN_DUONGSU>();
           
            obj.HS_ISKHIEUNAI =  1;
            // khong phai la bi cao thi cap nhat ten nguoi khieu nai
            if (obj.HS_ISBICAO != 1)
            {
                obj.TENDUONGSU = txtNguoiKN_HoTen.Text.Trim();
            }
            obj.DIACHI = txtNguoiKN_DiaChi.Text;
            obj.NGAYSUA = DateTime.Now;
            obj.NGUOISUA = UserName;
            dt.SaveChanges();
            lttMsgBC.Text = "Bạn đã cập nhật thành công";
        }
       

       
        protected void ThemNguoiKN()
        {
            don_id = GetDonID();
            //------------------------------
            GDTTT_VUAN_DUONGSU obj = new GDTTT_VUAN_DUONGSU();
            obj.VUANID = don_id;
            //Đối tượng khiêu nai
            obj.LOAI = Convert.ToDecimal(dropDoiTuongPhamToi.SelectedValue);
            obj.BICAOID = 0;
            obj.HS_TUCACHTOTUNG = "";
            obj.HS_BICANDAUVU =  0;
            obj.HS_ISBICAO = 0;
            obj.HS_ISKHIEUNAI = 1;
            obj.TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.KHAC;//khong phai la bi cao
            obj.TENDUONGSU = Cls_Comon.FormatTenRieng(txtNguoiKN_HoTen.Text.Trim());
            obj.DIACHI = txtNguoiKN_DiaChi.Text;
            
            obj.NGAYTAO = DateTime.Now;
            obj.NGUOITAO = UserName;
            obj.NGAYSUA = DateTime.Now;
            obj.NGUOISUA = UserName;
            dt.GDTTT_VUAN_DUONGSU.Add(obj);
            dt.SaveChanges();

            //Them thong tin nguoi duoc khieu nai
            if (dropBiCao.SelectedValue == "0")
            {
                lttMsgBC.Text = "Bạn phải chọn BC được khiếu nại";
                return;
            }
            Decimal NguoKNID = obj.ID;
            Decimal BicaoID = Convert.ToDecimal(dropBiCao.SelectedValue);
            Update_DuongSuKN(NguoKNID, BicaoID);            
            lttMsgBC.Text = "Bạn đã thêm mới thành công";
            
        }

        void Update_DuongSuKN(Decimal NguoiKNID,Decimal BiCaoID)
        {
            Decimal don_id = GetDonID();
            //-------------
            Boolean IsUpdate = false;
            GDTTT_VUAN_DS_KN oKN = new GDTTT_VUAN_DS_KN();
            GDTTT_VUAN_DS_KN objDSKN = new GDTTT_VUAN_DS_KN();
            try
            {
                List<GDTTT_VUAN_DS_KN> lst = dt.GDTTT_VUAN_DS_KN.Where(x => x.VUANID == don_id
                                                                     && x.BICAOID == BiCaoID
                                                                     && x.NGUOIKHIEUNAIID == NguoiKNID).ToList();
                if (lst != null && lst.Count > 0)
                {
                    oKN = lst[0];
                    IsUpdate = true;
                }
                else
                    oKN = new GDTTT_VUAN_DS_KN();
            }
            catch (Exception ex)
            {
                oKN = new GDTTT_VUAN_DS_KN();
            }
            oKN.BICAOID = BiCaoID;
            oKN.NGUOIKHIEUNAIID = NguoiKNID;
            oKN.VUANID = don_id;
            oKN.NOIDUNGKHIEUNAI = txtNguoiKN_NoiDung.Text.Trim();
            if (!IsUpdate)
            {
                dt.GDTTT_VUAN_DS_KN.Add(oKN);
            }
            dt.SaveChanges();
            //Neu bi cao la nguoi khieu nai thi upate hs_iskhieunai = 1 tai bang GDTTT_VUAN_DUONGSU
            GDTTT_VUAN_DUONGSU ds = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == NguoiKNID).First();
            if (ds.HS_BICANDAUVU == 1 || ds.HS_ISBICAO == 1)
            {
                ds.HS_ISKHIEUNAI = 1;
                dt.SaveChanges();
            } 

        }

        protected void cmdSaveNguoiKN_Click(object sender, EventArgs e)
        {
            Decimal NguoiKhieuNaiId = Convert.ToDecimal(dropNguoiKhieuNai.SelectedValue);
            if (NguoiKhieuNaiId == 0)
            {
                lttMsgBC.Text = "Bạn phải chọn người khiếu nại";
                return;
            }
            else if (NguoiKhieuNaiId == -1)
            { //thêm moi nguoi khieu nai và thong tin bi cao duoc khieu nai
                ThemNguoiKN();
            }
            else
            {
                //Thêm thông tin khiếu nại và bị cao duoc khieu nai
               
                Decimal BicaoID = Convert.ToDecimal(dropBiCao.SelectedValue);
                Update_DuongSuKN(NguoiKhieuNaiId, BicaoID);                
                // UpdateToiDanhChoDS(DuongSuID);
            }
            LoadDanhSachBiCao();
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }
        protected void cmdRefresh_Click(object sender, EventArgs e)
        {
            hddBiCaoID.Value = string.Empty;
            ClearFormBiCao();
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            lttMsgBC.Text = string.Empty;
        }
        protected void cmd_load_dstd_Click(object sender, EventArgs e)
        {
            LoadDanhSachBiCao();
        }
       
        public void LoadDanhSachBiCao()
        {
            don_id = GetDonID();
            hddVuAnID.Value = Convert.ToString(GetDonID());
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            //Hien thị danh sach thong tin Khieu nai
            //DataTable tbl = objBL.AnHS_GetAllDuongSu(don_id, "", 3);
            //DataTable tbl = objBL.AHS_GetAllBy_NguoiKN_BICAO(don_id); //Chi lay ra Nguoi khiêu nai
            DataTable tbl = objBL.AHS_GetAllByLoaiDS(don_id, 2); //Chi lay ra Nguoi khiêu nai
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows.Count);
                rptNguoiKN.DataSource = tbl;
                rptNguoiKN.DataBind();
                rptNguoiKN.Visible = true;
            }
            else rptNguoiKN.Visible = false;
        }
        protected void rptNguoiKN_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                String temp = ""; VuAnID = GetDonID();
                DataRowView dv = (DataRowView)e.Item.DataItem;
                Repeater rptBCKN = (Repeater)e.Item.FindControl("rptBCKN");
                Literal lttBiCao = (Literal)e.Item.FindControl("lttBiCao");
                Literal lttTenDS = (Literal)e.Item.FindControl("lttTenDS");
                //--------------------

                LinkButton lbtXoaKN = (LinkButton)e.Item.FindControl("lbtXoaKN");
                //--------------------

                lbtXoaKN.Visible = true;
                /////----
                Control td_sua_div = e.Item.FindControl("td_sua_div");
                int is_nguoikn = Convert.ToInt16(dv["HS_IsKhieuNai"] + "");
                int is_bicao = Convert.ToInt16(dv["HS_IsBiCao"] + "");
                int is_dauvu = Convert.ToInt16(dv["HS_BiCanDauVu"] + "");


                //----------------------
                if (is_bicao == 1 || is_dauvu == 1)
                {
                    lttTenDS.Text = dv["TenDuongSu"] + "";
                    if (is_dauvu == 1)
                        lttTenDS.Text += "<span class='loaibc'>(BC đầu vụ)</span>";
                    else if (is_bicao == 1 && is_nguoikn == 0)
                        lttTenDS.Text += "<span class='loaibc'>(Bị cáo)</span>";
                    else if (is_bicao == 1 && is_nguoikn == 1)
                        lttTenDS.Text += "<span class='loaibc'>(Người KN là BC)</span>";
                    String tentoidanh = String.IsNullOrEmpty(dv["HS_TenToiDanh"] + "") ? "" : "Tội danh:" + dv["HS_TenToiDanh"] + "";
                    String muc_an = String.IsNullOrEmpty(dv["HS_MucAn"] + "") ? "" : "Mức án: " + dv["HS_MucAn"] + "";
                    temp = muc_an + (String.IsNullOrEmpty(muc_an + "") ? "" : (string.IsNullOrEmpty(tentoidanh) ? "" : "</br>")) + tentoidanh;
                    if (is_nguoikn == 1)
                    {
                        temp += string.IsNullOrEmpty(temp) ? "" : (String.IsNullOrEmpty(dv["HS_NoiDungKhieuNai"] + "") ? "" : ("</br>Khiếu nại: " + dv["HS_NoiDungKhieuNai"].ToString()));
                        temp = "";//vua la bị cao , vua la nguoi khieu nai --> ko hien thong tin toidanh, muc an cua bc
                        //----------
                        td_sua_div.Visible = false;
                        LoadDsNguoiDuocKN(Convert.ToDecimal(dv["ID"] + ""), dv["HS_NoiDungKhieuNai"] + "", rptBCKN, lttBiCao);
                    }
                    else
                    {
                        td_sua_div.Visible = true;
                        lttBiCao.Text = temp;

                        rptBCKN.Visible = false;
                        lttBiCao.Visible = true;
                    }

                }
                else
                {
                    //---------------
                    lttTenDS.Text = dv["TenDuongSu"] + "";
                    if (is_bicao == 0 && is_nguoikn == 1)
                        lttTenDS.Text += "<span class='loaibc'> (Người KN)</span>";
                    //la nguoi khieu nai --> hien ds cac bi cao duoc kn, toi danh, muc an
                    Decimal NguoiKhieuNaiID = (Convert.ToDecimal(dv["ID"] + ""));
                    VuAnID = GetDonID();
                    GDTTT_VUANVUVIEC_DUONGSU_BL oBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
                    try
                    {
                        DataTable tbl = oBL.AHS_GetBiCaoKN_ByNguoiKN(VuAnID, NguoiKhieuNaiID);

                        if (tbl != null && tbl.Rows.Count > 0)
                        {
                            foreach (DataRow row in tbl.Rows)
                            {
                                temp = (row["BiCao_TuCachTT"] + "").Replace(", Người khiếu nại", "");
                                row["BiCao_TuCachTT"] = temp;
                            }
                            rptBCKN.Visible = true;
                            lttBiCao.Text = "<div style='float:left; width:100%; margin-bottom:3px;font-weight:bold;'>Người được khiếu nại:</div>";

                            rptBCKN.DataSource = tbl;
                            rptBCKN.DataBind();
                            td_sua_div.Visible = false;
                        }
                        else
                        {
                            td_sua_div.Visible = true;
                            lttBiCao.Text = "";
                            rptBCKN.Visible = false;
                            lttBiCao.Text = (String.IsNullOrEmpty(dv["HS_NoiDungKhieuNai"] + "") ? "" : ("</br>Khiếu nại: " + dv["HS_NoiDungKhieuNai"].ToString()));
                        }
                    }
                    catch (Exception ex)
                    {
                        lttBiCao.Text = (String.IsNullOrEmpty(dv["HS_NoiDungKhieuNai"] + "") ? "" : ("</br>Khiếu nại: " + dv["HS_NoiDungKhieuNai"].ToString()));
                    }
                }
            }
        }
        protected void rptNguoiKN_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0;
            VuAnID = GetDonID();
            switch (e.CommandName)
            {
                case "them_td":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_td_cc(" + curr_id + ");");
                    break;
                case "Xoa":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_VUAN_DUONGSU oT = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == curr_id).FirstOrDefault();
                    if (oT.HS_ISKHIEUNAI == 1)
                    {
                        //lttMsgBC.Text = "Bạn không thể xóa được người khiếu nại.";
                    }
                    else
                    {
                        curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                        XoaDuongSu_AnHS_BCKN(curr_id);
                        LoadDanhSachBiCao();
                        //LoadDropBiCao();
                        //lttMsgBC.Text = "Xóa bị cáo thành công";
                    }
                    break;

            }
        }
        protected void RptBCKN_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0;
            switch (e.CommandName)
            {
                case "SuaKN":
                    //curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    String temp = e.CommandArgument.ToString();
                    String[] arr = temp.Split('$');
                    curr_id = Convert.ToDecimal(arr[0] + "");
                    Decimal NguoiKhieuNaiID = Convert.ToDecimal(arr[1] + "");
                    Decimal BiCaoID = Convert.ToDecimal(arr[2] + "");
                    //txtNguoiKN_NoiDung.Text = arr[3] + "";
                    //Cls_Comon.SetValueComboBox(dropNguoiKhieuNai, NguoiKhieuNaiID);
                    //Cls_Comon.SetValueComboBox(dropBiCao, BiCaoID);
                    break;
                case "XoaKN":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    XoaDuongSu_AnHS_BCKN(curr_id);
                    LoadDanhSachBiCao();
                    //LoadDropBiCao();
                    //lttMsgBC.Text = "Bạn đã xóa thành công người được khiếu nại";
                    break;
            }
        }
        void XoaDuongSu_AnHS_BCKN(decimal curr_KN_id)
        {
            if (curr_KN_id > 0)
            {
                GDTTT_VUAN_DS_KN oT = dt.GDTTT_VUAN_DS_KN.Where(x => x.ID == curr_KN_id).FirstOrDefault();
                if (oT != null)
                {
                    Xoa_KN(curr_KN_id);
                    //------------------------------------
                    List<GDTTT_VUAN_DS_KN> inKN = null;
                    try {
                        inKN = dt.GDTTT_VUAN_DS_KN.Where(x => x.NGUOIKHIEUNAIID == oT.NGUOIKHIEUNAIID).ToList();
                    }
                    catch (Exception ex) { /*lbthongbao.Text = ex.Message;*/ }

                    //Neu khong thong tin khieu nai nao cua Nguoi KN nay thi xoa hoac cap nhat trong bang duóng su
                    if (inKN == null || inKN.Count == 0)
                    {
                        GDTTT_VUAN_DUONGSU oTs = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == oT.NGUOIKHIEUNAIID).FirstOrDefault();
                        //Neu nguoi khieu nai la bi cao
                        if (oTs.HS_BICANDAUVU == 1 || oTs.HS_ISBICAO == 1)
                        {
                            oTs.HS_ISKHIEUNAI = 0;
                            lttMsgBC.Text = "Bạn đã xóa công thành Nội dung khiếu nại";
                        }
                        else
                        {//Neu nguoi khieu nai khong phai la bi cao thi xóa người khiếu nại
                            dt.GDTTT_VUAN_DUONGSU.Remove(oTs);
                            lttMsgBC.Text = "Bạn đã xóa công thành người khiếu nại và Nội dung được khiếu nại";
                        }
                        dt.SaveChanges();
                    }
                }
                //------------------------------------
                // Update_TenVuAn(null);
            }
            
        }

        void Xoa_KN(Decimal KN_id)
        {
            //-------------------------------------
            GDTTT_VUAN_DS_KN obKN = dt.GDTTT_VUAN_DS_KN.Where(x => x.ID == KN_id).First();
            if (obKN != null)
            {
                dt.GDTTT_VUAN_DS_KN.Remove(obKN);
            }
            dt.SaveChanges();
        }

        void LoadDsNguoiDuocKN(Decimal NguoiKhieuNaiID, String NoidungKN, Repeater rptBCKN, Literal lttBiCao)
        {
            //Decimal NguoiKhieuNaiID = (Convert.ToDecimal(dv["ID"] + ""));
            String temp = "";

            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUANVUVIEC_DUONGSU_BL oBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            try
            {
                DataTable tbl = oBL.AHS_GetBiCaoKN_ByNguoiKN(CurrVuAnID, NguoiKhieuNaiID);

                if (tbl != null && tbl.Rows.Count > 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        temp = (row["BiCao_TuCachTT"] + "").Replace(", Người khiếu nại", "");
                        row["BiCao_TuCachTT"] = temp;
                    }
                    rptBCKN.Visible = true;
                    lttBiCao.Text += "<div style='float:left; width:100%; margin-bottom:3px;font-weight:bold;'> Người được khiếu nại:</div>";

                    rptBCKN.DataSource = tbl;
                    rptBCKN.DataBind();
                    //td_sua_div.Visible = false;
                }
                else
                {
                    //td_sua_div.Visible = true;
                    lttBiCao.Text = "";
                    rptBCKN.Visible = false;
                    lttBiCao.Text += (String.IsNullOrEmpty(NoidungKN) ? "" : ("</br>Khiếu nại: " + NoidungKN.ToString()));
                }
            }
            catch (Exception ex)
            {
                lttBiCao.Text += (String.IsNullOrEmpty(NoidungKN) ? "" : ("</br>Khiếu nại: " + NoidungKN.ToString()));
            }
        }
        
        public void LoadInfoBiCao()
        {
            try { ClearFormBiCao(); } catch (Exception ex) { }
            decimal CurrDuongSuID = Convert.ToDecimal(hddBiCaoID.Value);
            try
            {
                LoadThongTinBC_AHS(CurrDuongSuID);
            }
            catch (Exception ex) { }
        }
        void ClearFormBiCao()
        {
            dropNguoiKhieuNai.SelectedValue = "0";
            dropDoiTuongPhamToi.SelectedValue = "0";
            txtNguoiKN_HoTen.Text = "";
            txtNguoiKN_DiaChi.Text = "";
            dropBiCao.SelectedValue = "0";
            txtNguoiKN_NoiDung.Text = "";

        }
        void LoadThongTinBC_AHS(Decimal DuongSuID)
        {
            int is_dauvu = 0, is_bicao = 0;
            GDTTT_VUAN_DUONGSU obj = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == DuongSuID).Single();
            if (obj != null)
            {
                is_dauvu = String.IsNullOrEmpty(obj.HS_BICANDAUVU + "") ? 0 : Convert.ToInt16(obj.HS_BICANDAUVU + "");
                is_bicao = String.IsNullOrEmpty(obj.HS_ISBICAO + "") ? 0 : Convert.ToInt16(obj.HS_ISBICAO + "");
                
                txtNguoiKN_DiaChi.Text = obj.DIACHI;
            }
        }
        protected void dropDoiTuongPhamToi_SelectedIndexChanged(object sender, EventArgs e)
        {
            //if (dropDoiTuongPhamToi.SelectedValue == "0")
            //    lttHoTen.Text = "Họ và tên";
            //else if  (dropDoiTuongPhamToi.SelectedValue == "1")
            //    lttHoTen.Text = "Tên Cơ quan";
            //else if (dropDoiTuongPhamToi.SelectedValue == "2")
            //    lttHoTen.Text = "Tên Tổ chức";
            //else if (dropDoiTuongPhamToi.SelectedValue == "4")
            //    lttHoTen.Text = "Tên Pháp nhân";
            //else if (dropDoiTuongPhamToi.SelectedValue == "5")
            //    lttHoTen.Text = "Tên Pháp nhân";

        }
        
    }
}
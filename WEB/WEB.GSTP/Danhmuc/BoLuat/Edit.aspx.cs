using DAL.GSTP;
using BL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System.Web.UI.WebControls;

namespace WEB.GSTP.Danhmuc.BoLuat
{
    public partial class Edit : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public int TYPE = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                TYPE = String.IsNullOrEmpty(Request["type"] + "") ? 0 : Convert.ToInt16(hddType.Value);
                hddType.Value = TYPE.ToString();
                if (!IsPostBack)
                {
                    LoadDrop();
                    if (Request["boluatID"] != null)
                    {
                        try { dropBoLuat.SelectedValue = Request["boluatID"] + ""; } catch (Exception ex) { }
                        LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                    }
                    SetNewSTT();
                    //--------------------------------
                    decimal capcha_id = 0;
                    if (Request["pID"] != null)
                        capcha_id = Convert.ToDecimal(Request["pID"]);
                    LoadDropThanhPhan(capcha_id);
                    //----------------------
                    pnHinhPhat.Visible = false;
                    LoadListHinhPhat();

                    if (Request["cID"] != null)
                        LoadInfo(Convert.ToDecimal(Request["cID"] + ""));

                    //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        void Set_Value()
        {
            int loai = Convert.ToInt16(rdLoai.SelectedValue);
            //-------------------------------------
            String TieuDeForm = "";
            switch (loai)
            {
                case 1://chuong
                    TieuDeForm = "Thông tin chương";
                    lttDanhSach.Text = "Danh sách chương".ToUpper();
                    lblMa.Text = "Mã chương";
                    pnChuong.Visible = row_drop_dieu.Visible = row_drop_khoan.Visible = false;

                    break;
                case 2://dieu
                    TieuDeForm = "Thông tin điều";
                    lttDanhSach.Text = "Danh sách điều".ToUpper();
                    lblMa.Text = "Mã điều";
                    pnChuong.Visible = true;
                    row_drop_dieu.Visible = row_drop_khoan.Visible = false;
                    LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                    break;
                case 3: //khoan
                    TieuDeForm = "Thông tin khoản";
                    lttDanhSach.Text = "Danh sách khoản".ToUpper();
                    lblMa.Text = "Mã khoản";
                    pnChuong.Visible = row_drop_dieu.Visible = true;
                    row_drop_khoan.Visible = false;
                    LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                    dropDieu.Items.Add(new ListItem("---Chọn---", "0"));
                    break;
                case 4://diem
                    TieuDeForm = "Thông tin điểm";
                    lttDanhSach.Text = "Danh sách điểm".ToUpper();
                    lblMa.Text = "Mã điểm";
                    pnChuong.Visible = row_drop_dieu.Visible = row_drop_khoan.Visible = true;
                    LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                    dropDieu.Items.Add(new ListItem("---Chọn---", "0"));
                    dropKhoan.Items.Add(new ListItem("---Chọn---", "0"));
                    break;
                default:
                    TieuDeForm = "Thông tin";
                    lttDanhSach.Text = "Danh sách";
                    lblMa.Text = "Mã chương";
                    pnChuong.Visible = row_drop_dieu.Visible = row_drop_khoan.Visible = false;

                    break;
            }
            //lttTieuDeForm.Text = TieuDeForm.ToUpper();
        }
        
        void LoadDropThanhPhan(decimal capcha_id)
        {
            Decimal BoLuatID = Convert.ToDecimal(dropBoLuat.SelectedValue);
            // TYPE = Convert.ToInt16(hddType.Value);
            int loai = Convert.ToInt16(hddType.Value);
            pnIsHinhPhat.Visible = false;
            decimal chuong_id = 0, dieu_id = 0, khoan_id = 0;
            DM_BOLUAT_TOIDANH oT = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == capcha_id).FirstOrDefault();
            switch (loai)
            {
                case 1://chuong
                       //dropBoLuat.SelectedValue = oT.LUATID.ToString();
                    lblMa.Text = "Mã chương";
                    pnChuong.Visible = row_drop_dieu.Visible = row_drop_khoan.Visible = false;

                    break;
                case 2://dieu
                    hddMaChuong.Value = oT.CHUONG;
                    chuong_id = (Decimal)capcha_id;

                    LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                    try { dropChuong.SelectedValue = chuong_id.ToString(); } catch (Exception ex) { }

                    lblMa.Text = "Mã điều";
                    pnChuong.Visible = true;
                    row_drop_dieu.Visible = row_drop_khoan.Visible = false;
                    //LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                    pnIsHinhPhat.Visible = true;

                    break;
                case 3: //khoan
                    hddMaDieu.Value = oT.DIEU;
                    hddMaChuong.Value = oT.CHUONG;
                    //---------
                    dieu_id = capcha_id;
                    oT = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == dieu_id).FirstOrDefault();
                    chuong_id = (decimal)oT.CAPCHAID;

                    LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                    dropChuong.SelectedValue = chuong_id.ToString();

                    LoadDrop_ToiDanh_ByParentID(chuong_id, dropDieu);
                    dropDieu.SelectedValue = dieu_id.ToString();
                    pnIsHinhPhat.Visible = true;


                    lblMa.Text = "Mã khoản";
                    pnChuong.Visible = row_drop_dieu.Visible = true;
                    row_drop_khoan.Visible = false;
                    //LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                    //dropDieu.Items.Add(new ListItem("---Chọn---", "0"));

                    break;
                case 4://diem
                    hddMaKhoan.Value = oT.KHOAN;
                    hddMaDieu.Value = oT.DIEU;
                    hddMaChuong.Value = oT.CHUONG;

                    //----------------------------
                    khoan_id = (decimal)capcha_id;
                    oT = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == khoan_id).FirstOrDefault();
                    dieu_id = (decimal)oT.CAPCHAID;

                    oT = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == dieu_id).FirstOrDefault();
                    chuong_id = (decimal)oT.CAPCHAID;

                    LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                    dropChuong.SelectedValue = chuong_id.ToString();

                    LoadDrop_ToiDanh_ByParentID(chuong_id, dropDieu);
                    dropDieu.SelectedValue = dieu_id.ToString();

                    LoadDrop_ToiDanh_ByParentID(dieu_id, dropKhoan);
                    dropKhoan.SelectedValue = khoan_id.ToString();
                    pnIsHinhPhat.Visible = true;


                    lblMa.Text = "Mã điểm";
                    pnChuong.Visible = row_drop_dieu.Visible = row_drop_khoan.Visible = true;
                    //LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                    //dropDieu.Items.Add(new ListItem("---Chọn---", "0"));
                    //dropKhoan.Items.Add(new ListItem("---Chọn---", "0"));
                    break;
            }
          //  Set_Value();
        }
        void LoadDrop()
        {
            LoadDropByGroupName(dropLoaiToiPham, ENUM_DANHMUC.LOAITOIPHAM, true);
            LoadDropBoLuat();
            pnChuong.Visible = row_drop_dieu.Visible = row_drop_khoan.Visible = false;
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("------- Chọn --------", "0"));
            foreach (DataRow row in tbl.Rows)
            {
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
            }
        }

        void LoadDropBoLuat()
        {
            dropBoLuat.Items.Clear();
           // dropBoLuat.Items.Add(new ListItem("---Chọn---", "0"));
            List<DM_BOLUAT> lst = dt.DM_BOLUAT.Where(x => x.HIEULUC == 1).ToList();
            if (lst != null && lst.Count>0)
            {
                foreach (DM_BOLUAT item in lst)
                    dropBoLuat.Items.Add(new ListItem(item.TENBOLUAT, item.ID.ToString()));
            }
        }
        void LoadDrop_ToiDanh_ByParentID(Decimal ParentID, DropDownList drop)
        {
            Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            int level = Convert.ToInt16(hddType.Value);
            //int level = Convert.ToInt16(rdLoai.SelectedValue);
            drop.Items.Clear();
            drop.Items.Add(new ListItem("---Chọn---", "0"));
            List<DM_BOLUAT_TOIDANH> lst = null;
            lst = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == boluatid                                                    
                                               && x.CAPCHAID == ParentID).OrderBy(y => y.THUTU).ToList();           
            if (lst !=null)
            {
                   foreach(DM_BOLUAT_TOIDANH item in lst)
                        drop.Items.Add(new ListItem(item.TENTOIDANH, item.ID.ToString()));
            }
        }
        
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            String Old_ArrThuTu = "";
            String Old_ArrSapXep = "";
            DM_BOLUAT_TOIDANH obj = new DM_BOLUAT_TOIDANH();
            decimal CurrID = (String.IsNullOrEmpty(hddToiDanh.Value)) ? 0 : Convert.ToDecimal(hddToiDanh.Value);
            if (CurrID>0)
            {
                obj = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == CurrID).FirstOrDefault();
                if (obj != null)
                {
                    Old_ArrSapXep = obj.ARRSAPXEP;
                    obj.NGAYSUA = DateTime.Now;
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
            }
            obj.LUATID = Convert.ToDecimal(dropBoLuat.SelectedValue);
            obj.LOAITOIPHAM = Convert.ToDecimal(dropLoaiToiPham.SelectedValue);
            obj.TENTOIDANH = txtTenToiDanh.Text.Trim();
            obj.CHITIETTOIDANH = txtChiTietToiDanh.Text.Trim();

            obj.HIEULUC = Convert.ToInt16(rdHieuLuc.SelectedValue);
            obj.COHINHPHAT = Convert.ToInt16(rdIsHinhPhat.SelectedValue);
            obj.THUTU =(String.IsNullOrEmpty(txtThuTu.Text.Trim()))?1: Convert.ToDecimal(txtThuTu.Text.Trim());
            //obj.ISTHOIGIANTHUTHACH = Convert.ToDecimal( rdThoiGianThuThach.SelectedValue );

            if (CurrID == 0)
                obj.LOAI = Convert.ToDecimal(rdLoai.SelectedValue);
            int level = (int)obj.LOAI;
            switch (level)
            {
                case 1://chuong
                    obj.CHUONG = txtMa.Text.Trim();
                    obj.CAPCHAID = 0;
                    break;
                case 2://dieu
                    obj.CHUONG = hddMaChuong.Value;
                    obj.DIEU = txtMa.Text.Trim();
                    obj.CAPCHAID = Convert.ToDecimal(dropChuong.SelectedValue);
                    break;
                case 3: //khoan
                    obj.CHUONG = hddMaChuong.Value;
                    obj.DIEU = hddMaDieu.Value;
                    obj.KHOAN = txtMa.Text.Trim();
                    obj.CAPCHAID = Convert.ToDecimal(dropDieu.SelectedValue);
                    break;
                case 4://diem
                    obj.CHUONG = hddMaChuong.Value;
                    obj.DIEU = hddMaDieu.Value;
                    obj.KHOAN = hddMaKhoan.Value;

                    obj.DIEM = txtMa.Text.Trim();
                    obj.CAPCHAID = Convert.ToDecimal(dropKhoan.SelectedValue);
                    break;
            }

            //---------------------------------------
            //Check thu tu
            List<DM_BOLUAT_TOIDANH> lstcheck =  dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == obj.LUATID
                                                                            && x.CAPCHAID == obj.CAPCHAID
                                                                            && x.THUTU == obj.THUTU).ToList();
            if (lstcheck != null && lstcheck.Count>0)                
            {
                DM_BOLUAT_TOIDANH objCheck = lstcheck[0];
                if (objCheck.ID != CurrID)
                {
                    lbthongbao.Text = "<div class='error_msg'>Thứ tự trong cùng một cấp không được trùng nhau !</div>";
                    return;
                }
            }
            //---------------------------------------
            if (obj.CAPCHAID == 0)
                obj.ARRTHUTU = GetChuoiThuTu((int)obj.THUTU);
            else
            {
                String ParentArrThuTu = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == obj.CAPCHAID).Single().ARRTHUTU;
                obj.ARRTHUTU = ParentArrThuTu +"/"+ GetChuoiThuTu((int)obj.THUTU);
            }

            //---------------------------------------
            if (CurrID == 0)
            {
                obj.NGAYTAO = obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.DM_BOLUAT_TOIDANH.Add(obj);
            }
            dt.SaveChanges();
            if (CurrID > 0)
                UpdateThuTuc_ChildItem(obj.ID, obj.ARRTHUTU);

            CurrID = obj.ID;
            hddToiDanh.Value = obj.ID.ToString();
            Update_ArrSapXep(obj, Old_ArrSapXep);
          
            //---------------------------------
            UpdateHinhPhat(CurrID);
            
            //-----------------------
            txtTenToiDanh.Text = txtMa.Text = txtChiTietToiDanh.Text = "";
            rdIsHinhPhat.SelectedValue = "0";
            rdHieuLuc.SelectedValue = "1";

            ResetTree();
            //------------------------------
            lbthongbao.Text = "Lưu thành công!";
            //-----------------------------
            String para = "bID=" + dropBoLuat.SelectedValue;
            int loai = Convert.ToInt16(rdLoai.SelectedValue);
            if (loai >= 1 && dropChuong.SelectedValue != "0")
                para += "&chuongID=" + dropChuong.SelectedValue;
            if (loai >= 2 && dropDieu.SelectedValue != "0")
                para += "&dieuID=" + dropDieu.SelectedValue;
            if (loai > 3 && dropKhoan.SelectedValue != "0")
                para += "&khoanID=" + dropKhoan.SelectedValue;
            Response.Redirect("DsToiDanh.aspx?" + para);
        }
        void UpdateThuTuc_ChildItem(Decimal ParentID, string ParentArrThuTu)
        {
            try
            {
                List<DM_BOLUAT_TOIDANH> lst = dt.DM_BOLUAT_TOIDANH.Where(x => x.CAPCHAID == ParentID).ToList();
                foreach (DM_BOLUAT_TOIDANH obj in lst)
                {
                    obj.ARRTHUTU = ParentArrThuTu + "/" + GetChuoiThuTu((int)obj.THUTU);
                    dt.SaveChanges();
                    UpdateThuTuc_ChildItem(obj.ID, obj.ARRTHUTU);
                }
            }catch(Exception ex) { }
        }

        string GetChuoiThuTu(int intThutu)
        {
            string temp = "";
            if (intThutu < 10)
                temp = "0000" + intThutu.ToString();
            else if (intThutu < 100)
                temp = "000" + intThutu.ToString();
            else if (intThutu < 1000)
                temp = "00" + intThutu.ToString();
            else if (intThutu < 10000)
                temp = "0" + intThutu.ToString();
            else
                temp += intThutu.ToString();
            return temp;
        }
        void Update_ArrSapXep(DM_BOLUAT_TOIDANH obj, String Old_ArrSapXep)
        {
            String ArrSapXep = "";
            if (obj.CAPCHAID > 0)
            {
                DM_BOLUAT_TOIDANH objParent = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == obj.CAPCHAID).Single();
                if (objParent != null)
                    ArrSapXep = objParent.ARRSAPXEP + "/" + obj.ID.ToString();
            }
            else
                ArrSapXep = obj.ID.ToString();
            if (Old_ArrSapXep != ArrSapXep)
            {
                obj.ARRSAPXEP = ArrSapXep;
                dt.SaveChanges();


                //---------Update cac dl con theo duong dan moi cua nhom cha-------------------
                if (!String.IsNullOrEmpty(Old_ArrSapXep))
                {
                    string temp = Old_ArrSapXep + "/";
                    List<DM_BOLUAT_TOIDANH> lst = dt.DM_BOLUAT_TOIDANH.Where(x => x.ARRSAPXEP.Contains(temp)).ToList();
                    if (lst != null)
                    {
                        string new_arr_sapxep = "";
                        foreach (DM_BOLUAT_TOIDANH item in lst)
                        {
                            new_arr_sapxep = item.ARRSAPXEP.Replace(temp, ArrSapXep + "/");
                            item.ARRSAPXEP = new_arr_sapxep;
                        }
                        dt.SaveChanges();
                    }
                }
            }
        }

        void UpdateHinhPhat(decimal ToiDanhID)
        {
            DM_BOLUAT_TOIDANH_HINHPHAT obj = new DM_BOLUAT_TOIDANH_HINHPHAT();
            String StrXoa = ",";
            String Temp = ",";

            DM_BOLUAT_TOIDANH_HINHPHAT_BL objBL = new DM_BOLUAT_TOIDANH_HINHPHAT_BL();
            DataTable tbl = objBL.GetByToiDanhID(ToiDanhID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    Temp += row["HINHPHATID"] + ",";
            }

            //---------------------------------
            Decimal HinhPhatID = 0;

            foreach (TreeNode node in treeHinhPhat.Nodes)
            {
                if (node.ChildNodes.Count > 0)
                {
                    foreach (TreeNode nodeChild in node.ChildNodes)
                    {
                        if (nodeChild.Checked)
                        {
                            if (!Temp.Contains("," + nodeChild.Value + ","))
                            {
                                //Them moi
                                HinhPhatID = Convert.ToDecimal(nodeChild.Value);
                                obj = dt.DM_BOLUAT_TOIDANH_HINHPHAT.Where(x => x.TOIDANHID == ToiDanhID
                                                                            && x.HINHPHATID == HinhPhatID).FirstOrDefault();
                                if (obj == null)
                                {
                                    obj = new DM_BOLUAT_TOIDANH_HINHPHAT();
                                    obj.TOIDANHID = ToiDanhID;
                                    obj.HINHPHATID = HinhPhatID;
                                    obj.NGAYTAO = obj.NGAYSUA = DateTime.Now;
                                    obj.NGUOISUA = obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                    dt.DM_BOLUAT_TOIDANH_HINHPHAT.Add(obj);
                                    dt.SaveChanges();
                                }
                            }
                        }
                        else
                        {
                            if (Temp.Contains("," + nodeChild.Value + ","))
                                StrXoa += nodeChild.Value + ",";
                        }
                    }
                }
            }
            //------------------------
            if (StrXoa != ",")
            {
                String[] arr = StrXoa.Split(',');
                foreach (String item_del in arr)
                {
                    if (item_del.Length > 0)
                    {
                        HinhPhatID = Convert.ToInt32(item_del);
                        DM_BOLUAT_TOIDANH_HINHPHAT oT = dt.DM_BOLUAT_TOIDANH_HINHPHAT.Where(x => x.TOIDANHID == ToiDanhID && x.HINHPHATID == HinhPhatID).FirstOrDefault();
                        if (oT != null)
                            dt.DM_BOLUAT_TOIDANH_HINHPHAT.Remove(oT);
                    }
                }
                dt.SaveChanges();
            }
        }
       
        protected void Resetcontrol()
        {
            hddToiDanh.Value = "0";
            hddMaChuong.Value= hddMaDieu.Value= hddMaKhoan.Value =  "";
            //dropChuong.Items.Clear();
            //dropDieu.Items.Clear();
            //dropKhoan.Items.Clear();
            dropChuong.SelectedValue = dropDieu.SelectedValue = dropKhoan.SelectedValue = "0";

            txtTenToiDanh.Text = txtMa.Text = txtChiTietToiDanh.Text = "";

            rdIsHinhPhat.SelectedValue = "0";
            rdHieuLuc.SelectedValue = "1";

            txtThuTu.Text = "";
            ResetTree();
        }
        void ResetTree()
        {
            foreach (TreeNode node in treeHinhPhat.Nodes)
            {
                node.Checked = false;

                if (node.ChildNodes.Count > 0)
                {
                    foreach (TreeNode nodeChild in node.ChildNodes)
                        nodeChild.Checked = false;
                }
            }
        }
        public void LoadInfo(decimal ID)
        {
            DM_BOLUAT_TOIDANH oT = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == ID).FirstOrDefault();
            if (oT == null) return;
            {
                cmdUpdate.Visible = true;
                hddToiDanh.Value = ID.ToString();
                try { dropBoLuat.SelectedValue = oT.LUATID.ToString(); } catch (Exception ex) { }

                dropLoaiToiPham.SelectedValue = (string.IsNullOrEmpty(oT.LOAITOIPHAM + ""))? "0": oT.LOAITOIPHAM.ToString();
                txtTenToiDanh.Text = oT.TENTOIDANH;
                rdHieuLuc.SelectedValue = String.IsNullOrEmpty(oT.HIEULUC + "") ? "1":oT.HIEULUC.ToString();
                rdIsHinhPhat.SelectedValue = String.IsNullOrEmpty(oT.COHINHPHAT + "") ? "1" : oT.COHINHPHAT.ToString();
                txtChiTietToiDanh.Text = oT.CHITIETTOIDANH;
                txtThuTu.Text = String.IsNullOrEmpty(oT.THUTU + "") ? "1" : oT.THUTU.ToString();
                //rdThoiGianThuThach.SelectedValue = (string.IsNullOrEmpty(oT.ISTHOIGIANTHUTHACH + "")) ? "0" : oT.ISTHOIGIANTHUTHACH.ToString();
                
                decimal chuong_id = 0, dieu_id = 0, khoan_id = 0;
                int type = (int)oT.LOAI;
                try
                {
                    hddType.Value = type.ToString();
                    rdLoai.SelectedValue = String.IsNullOrEmpty(oT.LOAI + "") ? "1" : oT.LOAI.ToString();
                }
                catch(Exception ex) { }
                try
                {
                    LoadDropThanhPhan((Decimal)oT.CAPCHAID);
                }catch(Exception ex) { }

                switch (type)
                {
                    case 1://chuong
                        pnChuong.Visible = row_drop_dieu.Visible = row_drop_khoan.Visible = false;
                        txtMa.Text = oT.CHUONG;
                        hddMaChuong.Value = "";
                        hddMaDieu.Value = "";
                        hddMaKhoan.Value = "";
                        break;
                    case 2://dieu
                        pnChuong.Visible = true;
                        row_drop_dieu.Visible = row_drop_khoan.Visible = false;
                        txtMa.Text = oT.DIEU;
                        hddMaChuong.Value = oT.CHUONG;
                        //------------------------------
                        try { dropChuong.SelectedValue = oT.CAPCHAID.ToString(); } catch (Exception ex) { }
                        break;
                    case 3: //khoan
                        pnChuong.Visible = row_drop_dieu.Visible = true;
                        row_drop_khoan.Visible = false;
                        txtMa.Text = oT.KHOAN;
                        hddMaChuong.Value = oT.CHUONG;
                        hddMaDieu.Value = oT.DIEU;
                        //----------------------------------
                        dieu_id = (decimal)oT.CAPCHAID;
                        chuong_id = (decimal)dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == dieu_id).Single().CAPCHAID;
                        //---------
                        LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                        dropChuong.SelectedValue = chuong_id.ToString();

                        LoadDrop_ToiDanh_ByParentID(chuong_id, dropDieu);
                        dropDieu.SelectedValue = dieu_id.ToString();
                        break;
                    case 4://diem
                        pnChuong.Visible = row_drop_dieu.Visible = row_drop_khoan.Visible = true;
                        txtMa.Text = oT.DIEM;
                        hddMaChuong.Value = oT.CHUONG;
                        hddMaDieu.Value = oT.DIEU;
                        hddMaKhoan.Value = oT.KHOAN;
                        //----------------------------------
                        khoan_id = (decimal)oT.CAPCHAID;
                        dieu_id = (decimal)dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == khoan_id).Single().CAPCHAID;
                        chuong_id = (decimal)dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == dieu_id).Single().CAPCHAID;
                        //---------
                        LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                        dropChuong.SelectedValue = chuong_id.ToString();

                        LoadDrop_ToiDanh_ByParentID(chuong_id, dropDieu);
                        dropDieu.SelectedValue = dieu_id.ToString();

                        LoadDrop_ToiDanh_ByParentID(dieu_id, dropKhoan);
                        dropKhoan.SelectedValue = khoan_id.ToString();
                        //----------------------------------
                        break;
                }

                SetSelectedValue(oT.ID);
            }
        }
        void SetSelectedValue(decimal ToiDanhID)
        {
            DM_BOLUAT_TOIDANH_HINHPHAT_BL objBL = new DM_BOLUAT_TOIDANH_HINHPHAT_BL();
            DataTable tbl = objBL.GetByToiDanhID(ToiDanhID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rdIsHinhPhat.SelectedValue = "1";
                pnHinhPhat.Visible = true;
                foreach (DataRow row in tbl.Rows)
                {
                    foreach (TreeNode node in treeHinhPhat.Nodes)
                    {
                        if (node.Value == row["HINHPHATID"].ToString())
                            node.Checked = true;
                        else
                        {
                            if (node.ChildNodes.Count > 0)
                            {
                                foreach (TreeNode nodeChild in node.ChildNodes)
                                {
                                    if (nodeChild.Value == row["HINHPHATID"].ToString())
                                    {
                                        nodeChild.Checked = true;
                                        node.ExpandAll();
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                rdIsHinhPhat.SelectedValue = "0";
                pnHinhPhat.Visible = false;
            }
        }

        void LoadDropLienQuan()
        {
            int boluatid = Convert.ToInt32(dropBoLuat.SelectedValue);
            int loai  = Convert.ToInt16(rdLoai.SelectedValue);

            pnIsHinhPhat.Visible = false;
                String TieuDeForm = "";
                switch (loai)
                {
                    case 1://chuong
                        TieuDeForm = "Thông tin chương";
                        lttDanhSach.Text = "Danh sách chương".ToUpper();
                        lblMa.Text = "Mã chương";
                        pnChuong.Visible = row_drop_dieu.Visible = row_drop_khoan.Visible = false;
                        break;
                    case 2://dieu
                        TieuDeForm = "Thông tin điều";
                        lttDanhSach.Text = "Danh sách điều".ToUpper();
                        lblMa.Text = "Mã điều";
                        pnChuong.Visible = true;
                        row_drop_dieu.Visible = row_drop_khoan.Visible = false;
                        LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                        pnIsHinhPhat.Visible = true;
                    break;
                    case 3: //khoan
                        TieuDeForm = "Thông tin khoản";
                        lttDanhSach.Text = "Danh sách khoản".ToUpper();
                        lblMa.Text = "Mã khoản";
                        pnChuong.Visible = row_drop_dieu.Visible = true;
                        row_drop_khoan.Visible = false;
                        LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                        dropDieu.Items.Add(new ListItem("---Chọn---", "0"));
                        pnIsHinhPhat.Visible = true;
                        break;
                    case 4://diem
                        TieuDeForm = "Thông tin điểm";
                        lttDanhSach.Text = "Danh sách điểm".ToUpper();
                        lblMa.Text = "Mã điểm";
                        pnChuong.Visible = row_drop_dieu.Visible = row_drop_khoan.Visible = true;
                        LoadDrop_ToiDanh_ByParentID(0, dropChuong);
                        dropDieu.Items.Add(new ListItem("---Chọn---", "0"));
                        dropKhoan.Items.Add(new ListItem("---Chọn---", "0"));
                    pnIsHinhPhat.Visible = true;
                    break;
                    default:
                        TieuDeForm = "Thông tin";
                        lttDanhSach.Text = "Danh sách";
                        lblMa.Text = "Mã chương";
                        pnChuong.Visible = row_drop_dieu.Visible = row_drop_khoan.Visible = false;

                        break;
                }
                //lttTieuDeForm.Text = TieuDeForm.ToUpper();
        }   

        void LoadListHinhPhat()
        {
            treeHinhPhat.Nodes.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.NHOMHINHPHAT);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                TreeNode node = null;
                foreach (DataRow row in tbl.Rows)
                {
                    node = new TreeNode(row["Ten"] + "", "g_" + row["ID"] + "");
                    treeHinhPhat.Nodes.Add(node);
                    LoadNodeChild(node);
                }
            }
        }
        void LoadNodeChild(TreeNode nodeparent)
        {
            TreeNode node = null;
            Decimal Nhom = Convert.ToDecimal(nodeparent.Value.Replace("g_", ""));
            List<DM_HINHPHAT> lst = dt.DM_HINHPHAT.Where(x => x.NHOMHINHPHAT == Nhom).ToList<DM_HINHPHAT>();
            if (lst != null)
            {
                foreach (DM_HINHPHAT obj in lst)
                {
                    node = new TreeNode(obj.TENHINHPHAT, obj.ID.ToString());
                    nodeparent.ChildNodes.Add(node);
                }
            }
        }

        protected void dropBoLuat_SelectedIndexChanged(object sender, EventArgs e)
        {     
            LoadDrop_ToiDanh_ByParentID(0, dropChuong);
            SetNewSTT();
        }

        protected void dropChuong_SelectedIndexChanged(object sender, EventArgs e)
        {
            Decimal parentID = Convert.ToDecimal(dropChuong.SelectedValue);
            if(parentID>0)
            {
                DM_BOLUAT_TOIDANH obj = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == parentID).Single();
                hddMaChuong.Value = obj.CHUONG;

                LoadDrop_ToiDanh_ByParentID(parentID, dropDieu);
                SetNewSTT();
            }
        }

        protected void dropDieu_SelectedIndexChanged(object sender, EventArgs e)
        {
            Decimal parentID = Convert.ToDecimal(dropDieu.SelectedValue);
            if (parentID > 0)
            {
                DM_BOLUAT_TOIDANH obj = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == parentID).Single();
                hddMaDieu.Value = obj.DIEU;
                LoadDrop_ToiDanh_ByParentID(parentID, dropKhoan);
                SetNewSTT();
            }
        }

        protected void dropKhoan_SelectedIndexChanged(object sender, EventArgs e)
        {
            Decimal parentID = Convert.ToDecimal(dropKhoan.SelectedValue);
            if (parentID > 0)
            {
                DM_BOLUAT_TOIDANH obj = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == parentID).Single();
                hddMaKhoan.Value = obj.KHOAN;
                SetNewSTT();
            }
        }
        protected void rdIsHinhPhat_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdIsHinhPhat.SelectedValue=="1")
                pnHinhPhat.Visible = true;
            else
                pnHinhPhat.Visible = false;
        }

        protected void rdLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            hddType.Value = rdLoai.SelectedValue;
            Resetcontrol();
            LoadDropLienQuan();
            SetNewSTT();
        }
        protected void cmdQuayLai_Click(object sender, EventArgs e)
        {
            String para = "bID=" + dropBoLuat.SelectedValue;
            int loai = Convert.ToInt16(rdLoai.SelectedValue);
            if (loai >= 1 && dropChuong.SelectedValue != "0")
                para += "&chuongID=" + dropChuong.SelectedValue;
            if (loai >= 2 && dropDieu.SelectedValue != "0")
                para += "&dieuID=" + dropDieu.SelectedValue;
            if (loai > 3 && dropKhoan.SelectedValue != "0")
                para += "&khoanID=" + dropKhoan.SelectedValue;
            Response.Redirect("DsToiDanh.aspx?" + para);
        }
        string SetNewSTT()
        {
            String Str = "";
            int loai = Convert.ToInt16(rdLoai.SelectedValue);
            decimal boluat = Convert.ToDecimal(dropBoLuat.SelectedValue);
            Decimal CAPCHAID = 0;
            switch (loai)
            {
                case 1://chuongCAPCHAID = 0;
                    break;
                case 2://dieu
                    CAPCHAID = Convert.ToDecimal(dropChuong.SelectedValue);
                    break;
                case 3: //khoan
                    CAPCHAID = Convert.ToDecimal(dropDieu.SelectedValue);
                    break;
                case 4://diem
                   CAPCHAID = Convert.ToDecimal(dropKhoan.SelectedValue);
                    break;
            }

            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            int MaxTT = objBL.GetMaxTT(boluat, loai, CAPCHAID);

            txtThuTu.Text = (MaxTT+1).ToString();

            return Str;
        }
    }
}

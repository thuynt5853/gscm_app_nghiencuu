<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="pDanhSachAnPhi.aspx.cs" Inherits="WEB.GSTP.QLAN.pDanhSachAnPhi" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Danh sách vụ việc đã nộp tiền tạm ứng án phí, lệ phí Tòa án nhưng chưa thụ lý</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/chosen.jquery.js"></script>
</head>
<body>
    <style type="text/css">
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            overflow-y: auto;
            overflow-x: auto;
        }

        .col1 {
            width: 110px;
        }

        li {
            list-style: none;
        }

        .col2 {
            width: 206px;
        }

        .col3 {
            width: 105px;
        }

        .ajax__calendar_container {
            width: 180px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 145px;
        }
    </style>
    <asp:Panel ID="pnDS" runat="server">
        <form id="form1" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                    <div class="msg_thongbao" style="color:red">
                        <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
                    </div>
                    <div class="phantrang">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                OnClick="lbTBack_Click"><</asp:LinkButton>
                            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                OnClick="lbTNext_Click">></asp:LinkButton>
                            <asp:DropDownList ID="dropPageSize" runat="server" Width="65px"
                                CssClass="dropbox"
                                AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                            </asp:DropDownList>

                        </div>
                    </div>
                    <div class="boxchung">
                        <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" Visible="true" OnItemDataBound="rpt_ItemDataBound">
                            <HeaderTemplate>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table2" width="100%" border="1">
                                        <tr id="header" class="header">
                                            <td style="width: 20px;">TT</td>
                                            <td style="width: 300px;">Thông tin vụ việc</td>
                                            <td style="width: 300px;">Loại thông báo</td>
                                            <td style="width: 120px;">Biên lai trực tuyến</td>
                                            <td style="width: 300px;">Thông tin biên lai trực tiếp (THA)</td>
                                            <td style="width: 100px;">Người tạo</td>
                                            <%--<td style="width: 300px;" id="td_header_hoantra" runat="server">Thông tin người nhận hoàn trả tiền tạm ứng án phí</td>
                                            <td style="width: 200px;" runat="server" id="td_header_toaan">Tòa án giải quyết</td>
                                            <td style="width: 100px;" runat="server" id="td_header_TAMUNGANPHI">Số tiền tạm ứng án phí (VNĐ)</td>
                                            <td style="width: 100px;" runat="server" id="td_header_ANPHIHOANTRA">Số tiền hoàn trả (VNĐ)</td>
                                            <td style="width: 150px;" runat="server" id="td_header_trangthai">Trạng thái</td>
                                            <td style="width: 100px;" runat="server" id="td_header_xacnhan">Thông tin nộp tiền tạm ứng án phí</td>
                                            <td style="width: 200px;" runat="server" id="td_header_xacnhanhoantra">Thông tin nhận hoàn trả tiền tạm ứng án phí</td>
                                            <td style="width: 60px;" runat="server" id="td_header_FILEID">Tải thông báo</td>
                                            <td style="width: 120px;" runat="server" id="td_header_thaotac">Thao tác</td>--%>
                                        </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td style="text-align: center;"><%#Eval("STT") %> </td>
                                    <td>
                                        <ul>
                                            <%--<li style="text-align: left; font-style: italic;">Mã thông báo: <%#Eval("MA_THONGBAO")%></li>
                                            <li style="text-align: left; font-style: italic;">Số thông báo: <%#Eval("SOTHONGBAO")%></li>
                                            <li style="text-align: left; font-style: italic;">Ngày: <%#Eval("NGAYTHONGBAO")%></li>--%>
                                            <li><%#Eval("TENDUONGSU")%></li>
                                            <li style="text-align: left; font-style: italic;">Mã vụ việc: <%#Eval("MAVUVIEC")%></li>
                                            <%--<li style="text-align: left; font-style: italic;">Loại án: <%#Eval("LOAIAN")%></li>--%>
                                        </ul>
                                    </td>
                                    <td>
                                        <ul>
                                            <li><%#Eval("STATUS")%></li>
                                            <li style="text-align: left; font-style: italic;">Số thông báo: <%#Eval("SOTHONGBAO")%></li>
                                            <li style="text-align: left; font-style: italic;">Ngày: <%#Eval("NGAYTHONGBAO")%></li>
                                            <li style="text-align: left; font-style: italic;">Mã thông báo: <%#Eval("MA_THONGBAO")%></li>
                                        </ul>
                                    </td>
                                    <td id="td_item_xacnhan_tt" runat="server">
                                        <div class="align_left" style="display:none;">
                                            <div style="float: left">
                                                <ul>
                                                    <%--<li>Số biên lai: <%# Convert.ToString(Eval("TT_TRUCTUYEN")) == "1" ? Convert.ToString(Eval("SOBIENLAI")) : "" %></li>
                                                    <li>Ngày nộp: <%# Convert.ToString(Eval("TT_TRUCTUYEN")) == "1" ? Convert.ToString(Eval("NGAYBIENLAI")) : "" %></li>--%>
                                                    <li id="txtSoBienLai_TrucTuyen" runat="server"></li>
                                                    <li id="txtNgayBienLai_TrucTuyen" runat="server"></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="align_center">
                                            <div style="float: left; margin-left: 40px;margin-top:10px;">
                                                <asp:ImageButton ID="Dowload_Bienlai" runat="server" CausesValidation="false"
                                                    OnClick="cmdFile_Attach_Click" CommandName="DowloadBienlais" CommandArgument='<%#Eval("MA_THONGBAO").ToString() %>'
                                                    ImageUrl="/UI/img/download_file26.png" />
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="align_left">
                                            <div style="float: left">
                                                <ul>
                                                    <%--<li>Số biên lai: <%# Convert.ToString(Eval("TT_TRUCTUYEN")) == "0" ? Convert.ToString(Eval("SOBIENLAI")) : "" %></li>
                                                    <li>Ngày biên lai: <%# Convert.ToString(Eval("TT_TRUCTUYEN")) == "0" ? Convert.ToString(Eval("NGAYBIENLAI")) : "" %></li>--%>
                                                    <li id="txtSoBienLai_TrucTiep" runat="server"></li>
                                                    <li id="txtNgayBienLai_TrucTiep" runat="server"></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="align_center">
                                            <div style="float: left; margin-left: 10px; margin-top: 10px;">
                                                <asp:ImageButton ID="Dowload_Bienlai_thads" runat="server" CausesValidation="false"
                                                    OnClick="cmdFile_Attach_thads_Click" CommandName="DowloadBienlaithads" CommandArgument='<%#Eval("ANPHI_ID").ToString()+";"+ Eval("MALOAIVUVIEC").ToString() %>'
                                                    ImageUrl="/UI/img/pdf_blues.png" ToolTip="file biên lai từ Thi hành án dân sự cập nhật vào hệ thống"/>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <ul>
                                            <li><%#Eval("NGUOITHUTIEN")%></li>
                                        </ul>
                                    </td>
                                    <%--<td>
                                        <ul>
                                            <li><%#Eval("TENDUONGSU")%></li>
                                        </ul>
                                    </td>--%>
                                    <%--<td id="td_item_hoantra" runat="server">
                                        <ul>
                                            <li>Họ tên: <span style="font-weight: bold; font-size: 14px;"><%#Eval("HOANTRAAP_HOTEN")%></span></li>
                                            <li>Năm sinh: <%#Eval("HOANTRAAP_NAMSINH")%></li>
                                            <li>CMND: <%#Eval("HOANTRAAP_CMND")%></li>
                                            <li>Điện thoại: <%#Eval("HOANTRAAP_TEL")%></li>
                                            <li>Email: <%#Eval("HOANTRAAP_EMAIL")%></li>
                                            <li>Địa chỉ: <%#Eval("HOANTRAAP_DIACHI")%></li>
                                        </ul>
                                    </td>--%>
                                    <%--<td runat="server" id="td_item_toaan"><%#Eval("DONVI")%></td>--%>
                                    <%--<td style="text-align: right;" runat="server" id="td_item_TAMUNGANPHI"><%#Eval("TAMUNGANPHI")%> </td>
                                    <td style="text-align: right;" runat="server" id="td_item_ANPHIHOANTRA"><%#Eval("ANPHIHOANTRA")%> </td>--%>
                                    <%--<td id="td_item_trangthai" style="text-align: center;" runat="server">
                                        <ul>
                                            <li>Hình thức:<b style="color: #ff0000;"> <%#Eval("HINH_THUC")%></b></li>
                                            <li><%#Eval("STATUS")%></li>
                                            <li style="padding-top: 10px;"><%#Eval("STATUS_HOANTRA")%></li>
                                        </ul>
                                    </td>--%>
                                    <%--<td id="td_item_xacnhan" runat="server">
                                        <ul>
                                            <li>Ngày biên lai: <%#Eval("NGAYBIENLAI")%></li>
                                            <li>Số biên lai: <%#Eval("SOBIENLAI")%></li>
                                            <li>Người thu: <%#Eval("NGUOITHUTIEN")%></li>
                                        </ul>
                                    </td>--%>
                                    <%--<td id="td_item_xacnhan_tt" runat="server">
                                        <div class="align_left">
                                            <div style="float: left">
                                                <ul>
                                                    <li>Ngày biên lai: <%#Eval("NGAYBIENLAI")%></li>
                                                    <li>Số biên lai: <%#Eval("SOBIENLAI")%></li>
                                                    <li>Người thu: <%#Eval("NGUOITHUTIEN")%></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="align_center">
                                            <div style="float: left; margin-left: 40px;margin-top:10px;">
                                                <asp:ImageButton ID="Dowload_Bienlai" runat="server" CausesValidation="false"
                                                    OnClick="cmdFile_Attach_Click" CommandName="DowloadBienlais" CommandArgument='<%#Eval("MA_THONGBAO").ToString() %>'
                                                    ImageUrl="/UI/img/download_file26.png" />
                                            </div>
                                        </div>
                                    </td>--%>
                                    <%--<td id="td_item_xacnhanhoantra" runat="server">
                                        <ul>
                                            <li>Ngày nhận: <%#Eval("NGAYHOANTRA")%></li>
                                            <li>Số biên lai: <%#Eval("SOBIENLAI")%></li>
                                            <li>Người thu: <%#Eval("NGUOITHUTIEN")%></li>
                                        </ul>
                                    </td>--%>
                                    <%--<td id="td_FILEID" runat="server">
                                        <div class="align_center">
                                            <asp:ImageButton ID="cmdDowload" runat="server"
                                                CommandName="Dowload" CommandArgument='<%#Eval("FILEID")+";"+ Eval("MALOAIVUVIEC").ToString() %>'
                                                ImageUrl="/UI/img/download_file26.png" />
                                        </div>
                                    </td>
                                    <td id="td_item_thaotac" runat="server" style="text-align: center;">
                                        <a class="link_nopap" href="javascript:;" onclick="nopanphi('<%#Eval("MA_THONGBAO")%>','<%#Eval("DONID")%>','<%#Eval("DUONGSU_ID")%>','<%#Eval("MALOAIVUVIEC").ToString()%>','<%#Eval("BIEUMAUID")%>','<%#Eval("DUONGSU_IDS")%>','<%#Eval("ANPHI_ID")%>','<%#Eval("DVCQG_TT_ID")%>','0')">Cập nhật thông tin nộp án phí</a>
                                    </td>
                                    <td style="text-align: center; color: blue" id="td_item_xembienlai" runat="server">
                                        <p style="text-align: center;"><a class="link_nopap" href="javascript:;" onclick="nopanphi('<%#Eval("MA_THONGBAO")%>','<%#Eval("DONID")%>','<%#Eval("DUONGSU_ID")%>','<%#Eval("MALOAIVUVIEC").ToString()%>','<%#Eval("BIEUMAUID")%>','<%#Eval("DUONGSU_IDS")%>','<%#Eval("ANPHI_ID")%>','<%#Eval("DVCQG_TT_ID")%>','1')">Sửa thông tin nộp án phí</a></p>
                                        <p style="text-align: center; margin-top: 10px;">
                                            <a class="link_nopap" style="color: #9f1a12;" href="javascript:;" onclick="nopanphi('<%#Eval("MA_THONGBAO")%>','<%#Eval("DONID")%>','<%#Eval("DUONGSU_ID")%>','<%#Eval("MALOAIVUVIEC").ToString()%>','<%#Eval("BIEUMAUID")%>','<%#Eval("DUONGSU_IDS")%>','<%#Eval("ANPHI_ID")%>','<%#Eval("DVCQG_TT_ID")%>','2')">
                                                <asp:Label ID="lbl_hoantra" runat="server" Text="Cập nhật thông tin hoàn trả án phí"></asp:Label></a>
                                        </p>
                                        <p style="text-align: center; margin-top: 10px;">
                                            <asp:LinkButton ID="lblSua" runat="server" Text="Xem biên lai" CausesValidation="false" CommandName="xembienlai" ForeColor="#9f1a12" Font-Italic="true"
                                                CommandArgument='<%#Eval("MA_THONGBAO").ToString() +";"+Eval("DONID").ToString() +";"+ Eval("MALOAIVUVIEC").ToString()+";"+ Eval("DUONGSU_ID").ToString()+";"+ Eval("DUONGSU_IDS").ToString()%>'></asp:LinkButton>
                                        </p>
                                    </td>
                                    <td style="text-align: center; color: blue" id="td_item_xemhoantra" runat="server">
                                        <p style="text-align: center; margin-top: 8px;"><a class="link_nopap" style="color: #9f1a12;" href="javascript:;" onclick="nopanphi('<%#Eval("MA_THONGBAO")%>','<%#Eval("DONID")%>','<%#Eval("DUONGSU_ID")%>','<%#Eval("MALOAIVUVIEC").ToString()%>','<%#Eval("BIEUMAUID")%>','<%#Eval("DUONGSU_IDS")%>,'<%#Eval("ANPHI_ID")%>','<%#Eval("DVCQG_TT_ID")%>'','2')">Sửa thông tin hoàn trả án phí</a></p>
                                    </td>--%>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </table></div>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                    <div class="phantrang">
                        <div class="sobanghi">
                            <asp:HiddenField ID="hdicha" runat="server" />
                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                OnClick="lbTBack_Click"><</asp:LinkButton>
                            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>

                            <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                OnClick="lbTNext_Click">></asp:LinkButton>
                            <asp:DropDownList ID="dropPageSize2" runat="server" Width="65px" CssClass="dropbox"
                                AutoPostBack="True" OnSelectedIndexChanged="dropPageSize2_SelectedIndexChanged">
                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                            </asp:DropDownList>

                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                        &nbsp;&nbsp;
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        </form>
    </asp:Panel>
</body>

<script>
    Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
    function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }
</script>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
</html>

<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true"
    CodeBehind="UpdateTLDon.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.UpdateTLDon" %>

<%@ Register Src="~/Personnal/UC/DonKK_File.ascx" TagPrefix="uc1" TagName="DonKK_File" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .content_item_row {
            float: left;
            font-weight: bold;
            width: 100%;
        }

        #tblDetail tr td {
            background: white;
            padding: 10px 7px;
        }

        .title_form {
            float: left;
            width: 100%;
            text-transform: uppercase;
            font-weight: bold;
            margin-top: 10px;
            margin-bottom: 5px;
        }
    </style>

    <style>
        .table1 tr, td {
            padding-left: 0px;
        }
    </style>
    <asp:HiddenField ID="hddDonKKID" runat="server" />
      <asp:HiddenField ID="hddStatusDonKK" runat="server" />
    <asp:HiddenField ID="hddVuAnID" runat="server" />
    <asp:HiddenField ID="hddMaLoaiVuViec" runat="server" />
    <div class="right_full_width distance_bottom">
        <div class="thongtin_lienhe">
            <div class="right_full_width_head">
                <a href="javascript:;" class="dowload_head">Chi tiết</a>
                <div class="dangky_head_right">
                    <div class="tooltip">
                        <a href="/Personnal/Dsdon.aspx">
                            <img src="../UI/img/top_back.png" style="width: 28px; float: right;" />
                        </a>
                        <span class="tooltiptext  tooltip-bottom">Quay lại</span>
                    </div>

                </div>
            </div>
            <div class="content_right">
                <table style="background: #f5f5f5; width: 100%; margin-bottom: 15px;" cellpadding="1" id="tblDetail">
                    <tr>
                        <td style="width: 115px;" class="background_gray">Vụ việc</td>
                        <td>
                            <asp:Literal ID="lttVuViec" runat="server"></asp:Literal>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 115px;" class="background_gray">Tòa án thụ lý</td>
                        <td>
                            <asp:Literal ID="lttToaAn" runat="server"></asp:Literal>
                        </td>
                    </tr>
                       <tr>
                        <td style="width: 115px;" class="background_gray">Tình trạng đơn</td>
                        <td>
                            <asp:Literal ID="lttYeuCauBoSung" runat="server"></asp:Literal>
                        </td>
                    </tr>
                </table>
                <asp:Literal ID="lttThongBao" runat="server"></asp:Literal>


                <asp:Panel ID="pnVBTongDat" runat="server">
                    <div class="title_form">Bổ sung tài liệu</div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 85px;">Tên tài liệu</td>
                            <td>
                                <asp:TextBox ID="txtTenTaiLieu" runat="server"
                                    CssClass="textbox" Width="298px"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>Tệp đính kèm</td>
                            <td>
                                <asp:HiddenField ID="hddFilePath" runat="server" Value="0" />
                                <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                <asp:HiddenField ID="hddSessionID" runat="server" />
                                <asp:HiddenField ID="hddURLKS" runat="server" />
                                <div style="float: left; margin-right: 10px;">
                                    <button type="button" class="buttonkyso" id="FileUpload1" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                                    <div style="display:none;"><button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình</button></div><br />
                                    <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                                    </ul>
                                </div>

                                <!------------------>
                                <%--  <input type="file" id="FileUpload2" />
                                                        <input type="button" id="btnUploadFile" class="btnthemfile" value="Thêm tài liệu"
                                                            onclick="UploadFile();" />--%>
                                <div style="display:none;">
                                    <asp:Button ID="cmdThemFileTL" runat="server"
                                    CssClass="btnthemfile" Text="Them tai lieu_2"
                                    OnClick="cmdThemFileTL_Click" /></div>

                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="CSSTableGenerator" style="width: 100%;">
                                    <table style="width: 100%;">
                                        <tr id="row_header">
                                            <td style="width: 20px;">TT</td>
                                            <td>Tên tài liệu</td>
                                            <td style="width: 70px;">Xem file</td>
                                            <%--<asp:Literal ID="lttThaoTacFile" runat="server"></asp:Literal>--%>
                                        </tr>
                                        <asp:Repeater ID="rptFile" runat="server" OnItemCommand="rptFile_ItemCommand">
                                            <ItemTemplate>
                                                <tr>
                                                    <td><%# Container.ItemIndex + 1 %>
                                                        <asp:HiddenField ID="hddTaiLieuID" runat="server"
                                                            Value=' <%#Eval("ID") %>' />
                                                    </td>
                                                    <td>
                                                        <div style="text-align: justify; float: left;">
                                                            <%#Eval("TenTaiLieu") %>
                                                        </div>
                                                    </td>

                                                    <td>
                                                        <div style="text-align: center;">
                                                            <asp:ImageButton ID="cmdDowload" ImageUrl="/UI/img/dowload.png"
                                                                runat="server" ToolTip="Tải file xuống" Width="20px" CommandArgument='<%#Eval("ID").ToString() %>'
                                                                CommandName="dowload"></asp:ImageButton>
                                                        </div>
                                                    </td>

                                                    <%--   <td>
                                                        <div style="text-align: center;">
                                                            <asp:ImageButton ID="cmdXoa" runat="server" ImageUrl="/UI/img/delete.png"
                                                                CommandArgument='<%#Eval("ID").ToString() %>' CommandName="Delete" ToolTip="Xóa"
                                                                OnClientClick="return confirm('Bạn có thực sự muốn xóa mục này?');" Width="20px"></asp:ImageButton>
                                                        </div>
                                                    </td>--%>
                                                </tr>
                                            </ItemTemplate>

                                        </asp:Repeater>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>

                <div style="float: left; text-align: center; width: 100%; margin-top: 20px; margin-bottom: 20px">
                         <asp:Button ID="cmdGuiDon" runat="server" OnClick ="cmdGuiDon_Click"
                                    CssClass="buttoninput bg_do" Text="Gửi tài liệu bổ sung"/>
                    <a href="/Personnal/Dsdon.aspx" class="buttoninput bg_do">Quay lại</a>
                </div>
                <div style="display: none">
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        var count_file = 0;
        function VerifyPDFCallBack(rv) {}

        function exc_verify_pdf1() {
            var prms = {};
            var hddSession = document.getElementById('<%=hddSessionID.ClientID%>');
                prms["SessionId"] = "";
                prms["FileName"] = document.getElementById("file1").value;

                var json_prms = JSON.stringify(prms);

                vgca_verify_pdf(json_prms, VerifyPDFCallBack);
            }

            function SignFileCallBack1(rv) {
                var received_msg = JSON.parse(rv);
                if (received_msg.Status == 0) {
                    var hddFileKySo = document.getElementById('<%=hddFileKySo.ClientID%>');

                    var file_name = received_msg.FileName;
                    var file_path = received_msg.FileServer;

                    var new_item = document.createElement("li");
                    new_item.innerHTML = file_name;
                    hddFileKySo.value = file_path;

                    $("#<%= cmdThemFileTL.ClientID %>").click();
                } else {
                    document.getElementById("_signature").value = received_msg.Message;
                }
            }

            //metadata có kiểu List<KeyValue> 
            //KeyValue là class { string Key; string Value; }
            function exc_sign_file1() {
                var prms = {};
                var scv = [{ "Key": "abc", "Value": "abc" }];
                var hddURLKS = document.getElementById('<%=hddURLKS.ClientID%>');
                prms["FileUploadHandler"] = hddURLKS.value.replace(/^http:\/\//i, window.location.protocol + '//');
                prms["SessionId"] = "";
                prms["FileName"] = "";
                prms["MetaData"] = scv;
                var json_prms = JSON.stringify(prms);
                vgca_sign_file(json_prms, SignFileCallBack1);
            }
            function RequestLicenseCallBack(rv) {
                var received_msg = JSON.parse(rv);
                if (received_msg.Status == 0) {
                    document.getElementById("_signature").value = received_msg.LicenseRequest;
                } else {
                    alert("Ký số không thành công:" + received_msg.Status + ":" + received_msg.Error);
                }
            }
    </script>
    <%--    <script>
        function ValidateExtension() {
            var zone_message = document.getElementById('zone_message');
            var allowedFiles = [".doc", ".docx", ".pdf", ".jpg", ".jpeg", ".png"];
            var fileUpload = document.getElementById('FileUpload2');
            var regex = new RegExp("([a-zA-Z0-9\s_\\.\-:])+(" + allowedFiles.join('|') + ")$");
            if (!regex.test(fileUpload.value.toLowerCase())) {
                zone_message.style.display = "block";
                zone_message.innerText = 'Tài liệu chỉ cho phép chọn một trong các định dạng file: .doc, .docx, .pdf, .jpg, .jpeg, .png. Bạn hãy kiểm tra lại!';
                fileUpload.focus();
                return false;
            }
            return true;
        }
        function UploadFile() {
            if (!ValidateExtension()) {
                document.getElementById('FileUpload2').focus();
                return false;
            }
            else {
                var fileUpload = $("#FileUpload2").get(0);
                var files = fileUpload.files;
                var test = new FormData();
                for (var i = 0; i < files.length; i++) {
                    test.append(files[i].name, files[i]);
                }
                var file_name = document.getElementById('<%=txtTenTaiLieu.ClientID%>').value;

                $.ajax({
                    url: "UploadHandler.ashx?filename=" + file_name,
                    type: "POST",
                    contentType: false,
                    processData: false,
                    data: test,
                    // dataType: "json",
                    success: function (result) {
                        document.getElementById('<%=hddFilePath.ClientID%>').value = result;
                            $("#FileUpload2").val('');
                            $("#<%= cmdThemFileTL.ClientID %>").click();
                        },
                        error: function (err) {
                            //alert(err.statusText);
                        }
                });
            }
        }
    </script>--%>
</asp:Content>

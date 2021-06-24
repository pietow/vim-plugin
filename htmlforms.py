from dominate import tags as tags

def textforms(name):
    # ty='text'
    # label = tags.label(fr=name)
    # html_input = tags.input_(id=name, type=ty, name=name)
    # print(label)
    # print(html_input)
    form = tags.form()
    with form:
        for i in range(3):
            tags.label(fr=i)

    print(form)

textforms('bla')



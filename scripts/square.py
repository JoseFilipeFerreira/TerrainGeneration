#!/bin/python

NUM_PATCHES = 4
PATCH_SIZE = 1 / NUM_PATCHES

p1 = (0, 0, 0)
p2 = (0, 0, PATCH_SIZE)
p3 = (PATCH_SIZE, 0, PATCH_SIZE)
p4 = (PATCH_SIZE, 0, 0)


patches = [ ]

for i in range(NUM_PATCHES):
    for j in range(NUM_PATCHES):
        patches.append(
            (
               (p1[0] + i*PATCH_SIZE, 0 , p1[2] + j*PATCH_SIZE),
               (p2[0] + i*PATCH_SIZE, 0 , p2[2] + j*PATCH_SIZE),
               (p3[0] + i*PATCH_SIZE, 0 , p3[2] + j*PATCH_SIZE),
               (p4[0] + i*PATCH_SIZE, 0 , p4[2] + j*PATCH_SIZE)
            )
        )

print(4)
print(NUM_PATCHES*NUM_PATCHES)
print('y')
i = 0
for p in patches:
    print('{}, {}, {}, {}'.format(i,i+1,i+2,i+3))
    i += 4
print(NUM_PATCHES*NUM_PATCHES*4)
for p in patches:
    for v in p:
        print('{}, {}, {}'.format(v[0],v[1],v[2]))